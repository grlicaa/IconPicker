/*
 * Plug-in metadata for Icon Picker 3.0.
 *
 * The IDs below are the ones APEX generated for version 2.0 and MUST NOT change: keeping
 * them means importing 3.0 over an existing 2.0 install upgrades the plug-in in place and
 * every configured attribute value survives.
 */

export const PLUGIN = {
    id:              '208808430900605280',
    internalName:    'SI.ABAKUS.ICONPICKER',
    displayName:     'IconPicker',
    version:         '3.0',
    aboutUrl:        'https://github.com/grlicaa/IconPicker',
    filesVersion:    38,
    componentTypes:  'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS',
    standardAttributes:
        'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:ESCAPE_OUTPUT:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:PLACEHOLDER:ICON'
};

// Values taken from the 2.0 export so the generated file lands in the same workspace.
export const EXPORT_ENV = {
    versionYyyyMmDd: '2023.10.31',
    release:         '23.2.0',
    apexSchema:      'APEX_230200',
    workspaceId:     '2303530563576685',
    applicationId:   '216',
    idOffset:        '131865714620687320',
    owner:           'IGRALNICA'
};

const BOTH = 'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS';
const IG   = 'APEX_APPL_PAGE_IG_COLUMNS';

/*
 * Shared help. Page Designer renders attribute help as HTML, so line breaks have to be
 * explicit; the array entries are joined with newlines, which HTML collapses to spaces.
 */
const BLACKLIST_HELP = [
    'Hide icons from the picker. One entry per line, or comma separated.<br><br>',
    '<table>',
    '<tr><td><strong>fa-bomb, fa-skull</strong></td><td>&nbsp;an icon class name</td></tr>',
    '<tr><td><strong>COUNTRY_FLAG</strong></td><td>&nbsp;a whole category, as named on its tab</td></tr>',
    '<tr><td><strong>Country Flag</strong></td><td>&nbsp;the same - spaces and letter case are ignored</td></tr>',
    '<tr><td><strong>fa-flag-*</strong></td><td>&nbsp;a wildcard, hides every icon that matches</td></tr>',
    '<tr><td><strong>bomb</strong></td><td>&nbsp;the fa- prefix is optional</td></tr>',
    '</table>',
    '<br>',
    'A category that ends up empty disappears from the tabs as well as the grid.<br><br>',
    'An icon already stored in a row <strong>keeps rendering normally</strong> - blacklisting ',
    'only removes it from the picker, so it cannot be chosen again. Existing data is never ',
    'changed.<br><br>',
    '<strong>Category names you can use:</strong><br>',
    // build.mjs replaces this from the icon catalog, so it cannot go stale
    '%CATEGORIES%<br><br>',
    'Icon names are the Font APEX class names - open the picker and turn on ',
    '<strong>Show Icon Labels</strong> to read them, or hover any icon for its tooltip.<br>'
];

/*
 * Every "override the application setting" attribute uses this same three way list, so the
 * two behave identically. The values themselves need IDs unique within the plug-in.
 */
function overrideValues( baseId ) {
    return [
        { id: baseId + '1', display: 'Use application default', return: 'DEFAULT' },
        { id: baseId + '2', display: 'Yes',                     return: 'Y' },
        { id: baseId + '3', display: 'No',                      return: 'N' }
    ];
}

function overrideHelp( label, appDefault ) {
    return [
        `Override the application wide <strong>${ label }</strong> setting for this item only.`,
        '<br><br>',
        '<strong>Use application default</strong> - follow whatever is set under Shared ',
        'Components, Plug-ins, IconPicker. This is the default.<br>',
        `<strong>Yes</strong> / <strong>No</strong> - ignore the application setting for this `,
        'item.<br><br>',
        `The plug-in ships with the application default set to <strong>${ appDefault }</strong>.`
    ];
}

export const ATTRIBUTES = [
    {
        id: '208810565561615940', scope: 'APPLICATION', sequence: 1, display: 10,
        prompt: 'Dialog button hover title', type: 'TEXT', required: false,
        default: 'Open list of Icons', components: BOTH, translatable: true,
        help: [ 'On hover Icon Picker button, display title "Open list of Icons". (This is for easy translation to other languages.)' ]
    },
    {
        id: '208811250930618571', scope: 'APPLICATION', sequence: 2, display: 20,
        prompt: 'Dialog cancel button text', type: 'TEXT', required: true,
        default: 'Cancel', components: BOTH, translatable: true,
        help: [ 'On dialog windows, "Cancel" button title. (This is for easy translation to other languages.)' ]
    },
    {
        id: '208811752451621111', scope: 'APPLICATION', sequence: 3, display: 30,
        prompt: 'Dialog search field placeholder', type: 'TEXT', required: false,
        default: 'Search icons...', components: BOTH, translatable: true,
        help: [ 'Placeholder shown in the search field of the icon dialog.' ]
    },
    {
        id: '208812329671625019', scope: 'APPLICATION', sequence: 4, display: 40,
        prompt: 'SMALL icons label', type: 'TEXT', required: true,
        default: 'Small', components: BOTH, translatable: true,
        help: [ 'Label of the "small icons" size toggle.' ]
    },
    {
        id: '208812819427627608', scope: 'APPLICATION', sequence: 5, display: 50,
        prompt: 'LARGE icons label', type: 'TEXT', required: true,
        default: 'Large', components: BOTH, translatable: true,
        help: [ 'Label of the "large icons" size toggle.' ]
    },
    {
        id: '208813336271629981', scope: 'APPLICATION', sequence: 6, display: 60,
        prompt: 'Show Icon Labels', type: 'CHECKBOX', required: false,
        default: 'N', components: BOTH, translatable: false,
        help: [
            'Print the icon class name under every icon in the dialog, for example ',
            '<strong>fa-user</strong> below the person icon.<br><br>',
            'Default = <strong>No</strong>. With labels off the name is still announced to ',
            'screen readers and shown as a tooltip, so nothing is lost for accessibility.<br><br>',
            'This is the application wide default. Any individual page item or Interactive Grid ',
            'column can override it with its own <strong>Show Icon Labels</strong> setting.'
        ]
    },
    // Sequence 7 was "Use Widget:IconList" in 2.0. jQuery UI's iconList widget no longer
    // ships with APEX, so the attribute is dropped and the slot deliberately left empty.
    {
        id: '208817364821553001', scope: 'APPLICATION', sequence: 8, display: 70,
        prompt: 'Show Category Tabs', type: 'CHECKBOX', required: false,
        default: 'Y', components: BOTH, translatable: false,
        help: [
            'Show a row of category tabs above the icon grid (All, New, AI, Web application, ',
            'Country flag, ...) so users can narrow a 1500+ icon list down to one category.<br><br>',
            'Default = <strong>Yes</strong>.<br><br>',
            'This is the application wide default. Any individual page item or Interactive Grid ',
            'column can override it with its own <strong>Show Category Tabs</strong> setting.',
            '<br><br>',
            'To translate the tab names, create Text Messages called ',
            '<strong>IP.CATEGORY.&lt;CATEGORY&gt;</strong> - for example ',
            '<strong>IP.CATEGORY.WEB_APPLICATION</strong> or <strong>IP.CATEGORY.NEW</strong> - ',
            'with <strong>Used in JavaScript</strong> set to Yes. Untranslated categories keep ',
            'their English name.<br><br>',
            '<strong>Categories in this build:</strong><br>',
            // build.mjs replaces this from the icon catalog, so it cannot go stale
            '%CATEGORIES%<br><br>',
            'Your APEX release may have fewer: the picker checks its Font APEX stylesheet on ',
            'first open and drops whatever that release does not ship.<br><br>',
            'The script <strong>docs/text-messages/IP_messages_en.sql</strong> in the plug-in ',
            'repository creates every message, including one line per category, ready to ',
            'translate.'
        ]
    },
    {
        id: '208817364821553002', scope: 'APPLICATION', sequence: 9, display: 80,
        prompt: 'Blacklist Icons and Categories', type: 'TEXTAREA', required: false,
        components: BOTH, translatable: false,
        help: BLACKLIST_HELP.concat( [
            '<br>',
            'This is the application wide list. It is combined with the list on each page item ',
            'or Interactive Grid column - <strong>both lists always apply</strong>.'
        ] )
    },
    {
        id: '208813781871632529', scope: 'COMPONENT', sequence: 1, display: 10,
        prompt: 'Dialog title', type: 'TEXT', required: false,
        default: 'Icon Picker', components: BOTH, translatable: true,
        help: [ 'Dialog title, default value "Icon Picker".' ]
    },
    {
        id: '208814261077635845', scope: 'COMPONENT', sequence: 2, display: 20,
        prompt: 'Dialog re-sizable', type: 'CHECKBOX', required: false,
        default: 'Y', components: BOTH, translatable: false,
        help: [ 'Allow the user to resize the dialog by dragging its bottom right corner.' ]
    },
    {
        id: '208814795746638855', scope: 'COMPONENT', sequence: 3, display: 30,
        prompt: 'Dialog width', type: 'TEXT', required: false,
        default: '600', components: BOTH, translatable: false,
        help: [ 'Dialog width in pixels. Non-numeric values fall back to 600. The dialog never ',
                'grows wider than the browser window.' ]
    },
    {
        id: '208815269054640707', scope: 'COMPONENT', sequence: 4, display: 40,
        prompt: 'Dialog height', type: 'TEXT', required: false,
        default: '800', components: BOTH, translatable: false,
        help: [ 'Dialog height in pixels. Non-numeric values fall back to 800. The dialog never ',
                'grows taller than the browser window.' ]
    },
    {
        id: '208815776816643180', scope: 'COMPONENT', sequence: 5, display: 50,
        prompt: 'IG default icon', type: 'ICON', required: false,
        default: 'fa-navicon', components: IG, translatable: false,
        help: [ 'Icon shown on the button of an Interactive Grid cell that has no value yet.' ]
    },
    {
        id: '208816314668649692', scope: 'COMPONENT', sequence: 6, display: 60,
        prompt: 'IG only icon', type: 'CHECKBOX', required: false,
        default: 'N', components: IG, translatable: false,
        help: [ 'Yes = the Interactive Grid cell shows only the icon button.<br>',
                'No = the cell shows the text input next to the icon button.' ]
    },
    {
        id: '208816790769651776', scope: 'COMPONENT', sequence: 7, display: 70,
        prompt: 'IG Read Only', type: 'CHECKBOX', required: false,
        default: 'N', components: IG, translatable: false,
        help: [ 'Render the Interactive Grid cell read only.' ]
    },
    {
        id: '208817364821553010', scope: 'COMPONENT', sequence: 8, display: 80,
        prompt: 'Show Category Tabs', type: 'SELECT LIST', required: false,
        default: 'DEFAULT', components: BOTH, translatable: false,
        values: overrideValues( '20881736482155301' ),
        help: overrideHelp( 'Show Category Tabs', 'Yes' )
    },
    {
        id: '208817364821553020', scope: 'COMPONENT', sequence: 9, display: 90,
        prompt: 'Show Icon Labels', type: 'SELECT LIST', required: false,
        default: 'DEFAULT', components: BOTH, translatable: false,
        values: overrideValues( '20881736482155302' ),
        help: overrideHelp( 'Show Icon Labels', 'No' ).concat( [
            '<br><br>',
            'When on, the icon class name is printed under each icon, for example ',
            '<strong>fa-user</strong>.'
        ] )
    },
    {
        id: '208817364821553030', scope: 'COMPONENT', sequence: 10, display: 100,
        prompt: 'Blacklist Icons and Categories', type: 'TEXTAREA', required: false,
        components: BOTH, translatable: false,
        help: BLACKLIST_HELP.concat( [
            '<br>',
            'This list applies to this item only, <strong>on top of</strong> the application ',
            'wide list under Shared Components, Plug-ins, IconPicker. Both lists always apply; ',
            'an item cannot re-enable something the application has blacklisted.'
        ] )
    }
];

/*
 * Plug-in files, in load order. The IDs only have to be unique within the plug-in; these
 * are fresh because 3.0 renamed every file.
 */
export const FILES = [
    { id: '208818100000000010', name: 'js/icons.min.js',       source: 'dist/icons.min.js',       mime: 'application/javascript' },
    { id: '208818100000000020', name: 'js/iconpicker.min.js',  source: 'dist/iconpicker.min.js',  mime: 'application/javascript' },
    { id: '208818100000000030', name: 'css/iconpicker.min.css', source: 'dist/iconpicker.min.css', mime: 'text/css' }
];
