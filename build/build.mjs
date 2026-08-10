/*
 * build.mjs - produces the importable APEX plug-in export.
 *
 *   node build/build.mjs        (or: npm run build)
 *
 * Steps
 *   1. minify src/js/*.js and src/css/*.css into dist/
 *   2. read plsql/plugin_code.plsql
 *   3. emit plug-in/item_type_plugin_si_abakus_iconpicker_apex_232.sql, with every dist
 *      file hex encoded exactly the way APEX's own exporter writes them
 *   4. decode the generated hex back to bytes and assert it matches dist/, so a broken
 *      export can never reach the repository
 *
 * The export header targets APEX 23.2, which is the oldest release this version supports.
 * APEX accepts exports from its own release or older, so one file installs on 23.2 through
 * 26.1 and beyond.
 */

import { readFileSync, writeFileSync, mkdirSync, readdirSync, rmSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import * as esbuild from 'esbuild';

import { PLUGIN, EXPORT_ENV, ATTRIBUTES, FILES } from './plugin-metadata.mjs';

const ROOT   = join( dirname( fileURLToPath( import.meta.url ) ), '..' );
const DIST   = join( ROOT, 'dist' );
const TARGET = join( ROOT, 'plug-in', 'item_type_plugin_si_abakus_iconpicker_apex_232.sql' );

const BYTES_PER_LINE = 100;      // 200 hex characters, same as an APEX generated export

// ---------------------------------------------------------------------------
// PL/SQL literal helpers
// ---------------------------------------------------------------------------

/** A PL/SQL single quoted literal. */
function q( value ) {
    return "'" + String( value ).replace( /'/g, "''" ) + "'";
}

/** wwv_flow_string.join(...) over an array of source lines, the way APEX writes them. */
function joinLines( lines ) {
    return 'wwv_flow_string.join(wwv_flow_t_varchar2(\n'
        + lines.map( line => q( line ) ).join( ',\n' )
        + '))';
}

/** A single line value, or a joined multi-line value when it does not fit on one. */
function textValue( lines ) {
    return lines.length === 1 ? q( lines[ 0 ] ) : joinLines( lines );
}

// ---------------------------------------------------------------------------
// 1. minify
// ---------------------------------------------------------------------------

function minify() {
    rmSync( DIST, { recursive: true, force: true } );
    mkdirSync( DIST, { recursive: true } );

    const jobs = [
        { from: 'src/js/icons.js',        to: 'icons.min.js',       loader: 'js' },
        { from: 'src/js/iconpicker.js',   to: 'iconpicker.min.js',  loader: 'js' },
        { from: 'src/css/iconpicker.css', to: 'iconpicker.min.css', loader: 'css' }
    ];

    for ( const job of jobs ) {
        const source = readFileSync( join( ROOT, job.from ), 'utf8' );
        const result = esbuild.transformSync( source, {
            loader:       job.loader,
            minify:       true,
            legalComments: 'inline',        // keep the /*! banner
            target:       [ 'es2019', 'chrome80', 'firefox78', 'safari14', 'edge80' ]
        } );

        if ( result.warnings.length ) {
            for ( const warning of result.warnings ) {
                console.warn( `  warning ${ job.from }: ${ warning.text }` );
            }
        }

        writeFileSync( join( DIST, job.to ), result.code );
        console.log( `  ${ job.from } -> dist/${ job.to } (${ result.code.length } bytes)` );
    }
}

// ---------------------------------------------------------------------------
// 3. hex encoded plug-in files
// ---------------------------------------------------------------------------

function hexLines( buffer ) {
    const lines = [];

    for ( let offset = 0; offset < buffer.length; offset += BYTES_PER_LINE ) {
        lines.push( buffer.subarray( offset, offset + BYTES_PER_LINE ).toString( 'hex' ).toUpperCase() );
    }
    return lines;
}

function fileBlock( file, buffer ) {
    const assignments = hexLines( buffer )
        .map( ( hex, index ) => `wwv_flow_imp.g_varchar2_table(${ index + 1 }) := '${ hex }';` )
        .join( '\n' );

    return [
        'begin',
        'wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;',
        assignments,
        'null;',
        'end;',
        '/',
        'begin',
        'wwv_flow_imp_shared.create_plugin_file(',
        ` p_id=>wwv_flow_imp.id(${ file.id })`,
        `,p_plugin_id=>wwv_flow_imp.id(${ PLUGIN.id })`,
        `,p_file_name=>${ q( file.name ) }`,
        `,p_mime_type=>${ q( file.mime ) }`,
        ',p_file_charset=>\'utf-8\'',
        ',p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)',
        ');',
        'end;',
        '/'
    ].join( '\n' );
}

// ---------------------------------------------------------------------------
// plug-in definition
// ---------------------------------------------------------------------------

/**
 * Category keys, straight from the icon catalog. Attribute help quotes the list so a
 * developer can see what is blacklistable without opening icons.js, and taking it from the
 * catalog means a Font APEX bump cannot leave the help lying.
 */
function catalogCategories() {
    const sandbox = {};

    new Function( 'window', readFileSync( join( ROOT, 'src', 'js', 'icons.js' ), 'utf8' ) )( sandbox );

    return Object.keys( sandbox.abakusIconPicker.icons );
}

const CATEGORIES = catalogCategories();

/** Fills %CATEGORIES% in help text with the live list. */
function expandHelp( lines ) {
    return lines.map( line => line.replace( /%CATEGORIES%/g, CATEGORIES.join( ', ' ) ) );
}

function attributeBlock( attribute ) {
    const lines = [
        'wwv_flow_imp_shared.create_plugin_attribute(',
        ` p_id=>wwv_flow_imp.id(${ attribute.id })`,
        `,p_plugin_id=>wwv_flow_imp.id(${ PLUGIN.id })`,
        `,p_attribute_scope=>${ q( attribute.scope ) }`,
        `,p_attribute_sequence=>${ attribute.sequence }`,
        `,p_display_sequence=>${ attribute.display }`,
        `,p_prompt=>${ q( attribute.prompt ) }`,
        `,p_attribute_type=>${ q( attribute.type ) }`,
        `,p_is_required=>${ attribute.required ? 'true' : 'false' }`
    ];

    if ( attribute.default !== undefined ) {
        lines.push( `,p_default_value=>${ q( attribute.default ) }` );
    }

    lines.push( ',p_supported_ui_types=>\'DESKTOP\'' );
    lines.push( `,p_supported_component_types=>${ q( attribute.components ) }` );
    lines.push( `,p_is_translatable=>${ attribute.translatable ? 'true' : 'false' }` );

    if ( attribute.help ) {
        lines.push( `,p_help_text=>${ textValue( expandHelp( attribute.help ) ) }` );
    }

    lines.push( ');' );

    // A SELECT LIST attribute carries its options as separate rows. Display sequences go
    // 10, 20, 30 the way an APEX generated export writes them.
    ( attribute.values || [] ).forEach( ( value, index ) => {
        lines.push(
            'wwv_flow_imp_shared.create_plugin_attr_value(',
            ` p_id=>wwv_flow_imp.id(${ value.id })`,
            `,p_plugin_attribute_id=>wwv_flow_imp.id(${ attribute.id })`,
            `,p_display_sequence=>${ ( index + 1 ) * 10 }`,
            `,p_display_value=>${ q( value.display ) }`,
            `,p_return_value=>${ q( value.return ) }`,
            ');' );
    } );

    return lines.join( '\n' );
}

function pluginBlock( plsqlLines ) {
    const definition = [
        'wwv_flow_imp_shared.create_plugin(',
        ` p_id=>wwv_flow_imp.id(${ PLUGIN.id })`,
        ',p_plugin_type=>\'ITEM TYPE\'',
        `,p_name=>${ q( PLUGIN.internalName ) }`,
        `,p_display_name=>${ q( PLUGIN.displayName ) }`,
        ',p_supported_ui_types=>\'DESKTOP\'',
        `,p_supported_component_types=>${ q( PLUGIN.componentTypes ) }`,
        ',p_javascript_file_urls=>' + joinLines(
            FILES.filter( file => file.mime === 'application/javascript' )
                 .map( file => `#PLUGIN_FILES#${ file.name }` )
                 .concat( [ '' ] ) ),
        ',p_css_file_urls=>' + q(
            '#PLUGIN_FILES#' + FILES.find( file => file.mime === 'text/css' ).name ),
        ',p_plsql_code=>' + joinLines( plsqlLines.concat( [ '' ] ) ),
        ',p_api_version=>2',
        ',p_render_function=>\'render\'',
        ',p_meta_data_function=>\'metadata_ig_icon_picker\'',
        `,p_standard_attributes=>${ q( PLUGIN.standardAttributes ) }`,
        ',p_substitute_attributes=>true',
        ',p_subscribe_plugin_settings=>true',
        `,p_version_identifier=>${ q( PLUGIN.version ) }`,
        `,p_about_url=>${ q( PLUGIN.aboutUrl ) }`,
        `,p_files_version=>${ PLUGIN.filesVersion }`,
        ');'
    ].join( '\n' );

    return [
        'prompt --application/shared_components/plugins/item_type/si_abakus_iconpicker',
        'begin',
        definition,
        ATTRIBUTES.map( attributeBlock ).join( '\n' ),
        'end;',
        '/'
    ].join( '\n' );
}

function header() {
    return [
        'prompt --application/set_environment',
        'set define off verify off feedback off',
        'whenever sqlerror exit sql.sqlcode rollback',
        '--------------------------------------------------------------------------------',
        '--',
        '-- Oracle APEX export file',
        '--',
        '-- You should run the script connected to SQL*Plus as the Oracle user',
        `-- ${ EXPORT_ENV.apexSchema } or as the owner (parsing schema) of the application.`,
        '--',
        '-- NOTE: Calls to apex_application_install override the defaults below.',
        '--',
        '-- Generated by build/build.mjs from src/ and plsql/. Do not edit by hand.',
        '--',
        '--------------------------------------------------------------------------------',
        'begin',
        'wwv_flow_imp.import_begin (',
        ` p_version_yyyy_mm_dd=>${ q( EXPORT_ENV.versionYyyyMmDd ) }`,
        `,p_release=>${ q( EXPORT_ENV.release ) }`,
        `,p_default_workspace_id=>${ EXPORT_ENV.workspaceId }`,
        `,p_default_application_id=>${ EXPORT_ENV.applicationId }`,
        `,p_default_id_offset=>${ EXPORT_ENV.idOffset }`,
        `,p_default_owner=>${ q( EXPORT_ENV.owner ) }`,
        ');',
        'end;',
        '/',
        '',
        `prompt APPLICATION ${ EXPORT_ENV.applicationId } - Icon Picker [Plug-in]`,
        '--',
        '-- Application Export:',
        `--   Name:            Icon Picker [Plug-in] ${ PLUGIN.version }`,
        `--   Manifest`,
        `--     PLUGIN: ${ PLUGIN.id }`,
        '--   Manifest End',
        `--   Version:         ${ EXPORT_ENV.release }`,
        '--',
        '',
        'begin',
        '  -- replace components',
        '  wwv_flow_imp.g_mode := \'REPLACE\';',
        'end;',
        '/'
    ].join( '\n' );
}

function footer() {
    return [
        'prompt --application/end_environment',
        'begin',
        'wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));',
        'commit;',
        'end;',
        '/',
        'set verify on feedback on define on',
        'prompt  ...done',
        ''
    ].join( '\n' );
}

// ---------------------------------------------------------------------------
// 4. round trip check
// ---------------------------------------------------------------------------

/**
 * Reads the hex back out of the generated SQL and compares it to what is on disk. A silent
 * corruption here would only surface as a broken plug-in inside somebody's application, so
 * the build fails loudly instead.
 */
function verify( sql, buffers ) {
    const blocks = sql.split( 'wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;' ).slice( 1 );

    if ( blocks.length !== FILES.length ) {
        throw new Error( `expected ${ FILES.length } file blocks, found ${ blocks.length }` );
    }

    FILES.forEach( ( file, index ) => {
        const hex = [ ...blocks[ index ].matchAll( /g_varchar2_table\(\d+\) := '([0-9A-F]*)';/g ) ]
            .map( match => match[ 1 ] )
            .join( '' );
        const decoded = Buffer.from( hex, 'hex' );

        if ( !decoded.equals( buffers[ index ] ) ) {
            throw new Error( `round trip failed for ${ file.name }: `
                + `${ decoded.length } bytes decoded, ${ buffers[ index ].length } bytes expected` );
        }

        console.log( `  ${ file.name }: ${ buffers[ index ].length } bytes round tripped` );
    } );
}

// ---------------------------------------------------------------------------

console.log( 'Minifying' );
minify();

console.log( 'Generating plug-in export' );

const plsqlLines = readFileSync( join( ROOT, 'plsql', 'plugin_code.plsql' ), 'utf8' )
    .replace( /\r\n/g, '\n' )
    .replace( /\s+$/, '' )
    .split( '\n' );

const tooLong = plsqlLines.find( line => line.length > 4000 );

if ( tooLong ) {
    throw new Error( 'plugin_code.plsql has a line longer than 4000 characters' );
}

const buffers = FILES.map( file => readFileSync( join( ROOT, file.source ) ) );

const sql = [
    header(),
    pluginBlock( plsqlLines ),
    ...FILES.map( ( file, index ) => fileBlock( file, buffers[ index ] ) ),
    footer()
].join( '\n' );

writeFileSync( TARGET, sql );

console.log( 'Verifying' );
verify( sql, buffers );

// The README documents the category names a developer can blacklist or translate. It is
// written by hand, so the build checks it still matches the catalog rather than trusting it.
const readme  = readFileSync( join( ROOT, 'README.md' ), 'utf8' );
const undocumented = CATEGORIES.filter( category => !readme.includes( '`' + category + '`' ) );

if ( undocumented.length ) {
    throw new Error(
        `README.md does not document these categories: ${ undocumented.join( ', ' ) }.\n`
        + '  Add them to the category table, or the blacklist and translation docs will be wrong.' );
}

console.log( `  README documents all ${ CATEGORIES.length } categories` );

console.log( `\nWrote ${ TARGET.replace( ROOT + '\\', '' ).replace( ROOT + '/', '' ) } `
    + `(${ sql.length } bytes, ${ readdirSync( DIST ).length } embedded files)` );
