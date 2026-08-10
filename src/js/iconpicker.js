/*!
 * Icon Picker 3.0 - Oracle APEX item plug-in
 * https://github.com/grlicaa/IconPicker
 *
 * Replaces IPdoc.js and IPgrid.js from 2.0.
 *
 * Notable differences from 2.0:
 *   - one native <dialog>, created once per page, instead of a jQuery UI dialog per item
 *     (jQuery UI is deprecated in APEX and $.fn.iconList no longer exists at all)
 *   - grid entries are real <button> elements bound through one delegated listener, so
 *     there are no "javascript:" URLs for a Content Security Policy to reject
 *   - everything hangs off window.abakusIconPicker, no other globals
 */
( function ( global, $ ) {
    "use strict";

    var ip = global.abakusIconPicker = global.abakusIconPicker || {};

    var DIALOG_ID   = "abakusIconPickerDialog",
        SIZE_KEY    = "abakusIconPicker.size",
        SIZE_LARGE  = "LARGE",
        SIZE_SMALL  = "SMALL",
        ALL_CHIP    = "__ALL__",          // sentinel, cannot collide with a Font APEX category key
        SEARCH_WAIT = 200;

    // dialog state - one dialog for the whole page, whatever the item count
    var dialog$,
        searchInput,
        gridContainer,
        chipContainer,
        titleElement,
        cancelButton,
        activeTarget,                       // set while the dialog is open
        activeCategory  = ALL_CHIP,
        returnFocusTo   = null,
        searchTimer     = null,
        mergeAttempted  = false;

    // interactive grid columns whose delegated click handler is already bound
    var boundGridColumns = Object.create( null );

    // ------------------------------------------------------------------
    // small helpers
    // ------------------------------------------------------------------

    function escapeHtml( text ) {
        if ( global.apex && global.apex.util && global.apex.util.escapeHTML ) {
            return global.apex.util.escapeHTML( String( text ) );
        }
        return String( text ).replace( /[&<>"']/g, function ( c ) {
            return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[ c ];
        } );
    }

    function storedSize() {
        try {
            return global.localStorage.getItem( SIZE_KEY ) === SIZE_LARGE ? SIZE_LARGE : SIZE_SMALL;
        } catch ( e ) {
            return SIZE_SMALL;
        }
    }

    function storeSize( size ) {
        try {
            global.localStorage.setItem( SIZE_KEY, size );
        } catch ( e ) {
            // private browsing, storage disabled - the toggle just will not persist
        }
    }

    // category keys are rendered lower case and capitalised by CSS, which turns the one
    // acronym in the catalog into "Ai"
    var CATEGORY_LABELS = { AI: "AI" };

    function categoryLabel( category ) {
        return CATEGORY_LABELS[ category ] || category.replace( /_/g, " " ).toLowerCase();
    }

    // ------------------------------------------------------------------
    // catalog
    // ------------------------------------------------------------------

    /**
     * Every icon in the bundled catalog, de-duplicated. Categories overlap - "NEW" repeats
     * icons that also live in their own category - so search must run over a flat unique set.
     */
    function flatIcons() {
        var seen = Object.create( null ),
            flat = [];

        Object.keys( ip.icons ).forEach( function ( category ) {
            ip.icons[ category ].forEach( function ( icon ) {
                if ( !seen[ icon.name ] ) {
                    seen[ icon.name ] = true;
                    flat.push( icon );
                }
            } );
        } );

        return flat;
    }

    // ------------------------------------------------------------------
    // runtime merge
    //
    // Best effort only. When the instance serves images from the Oracle CDN the Font APEX
    // stylesheet is cross-origin: reading cssRules raises SecurityError and the fetch may be
    // refused by CORS. Both failures are swallowed and the bundled catalog is used as-is.
    // On the common on-premises "/i/" same-origin setup the CSSOM path works and any icon
    // added by a newer Font APEX than the one bundled here shows up under OTHER.
    // ------------------------------------------------------------------

    var ICON_RULE = /\.fa-([a-z0-9]+(?:-[a-z0-9]+)*)::?before/gi;

    function namesFromCss( cssText, found ) {
        var match;

        ICON_RULE.lastIndex = 0;
        while ( ( match = ICON_RULE.exec( cssText ) ) !== null ) {
            found[ "fa-" + match[ 1 ] ] = true;
        }
    }

    function namesFromCssom( found ) {
        var sheets = global.document.styleSheets,
            i, rules, j;

        for ( i = 0; i < sheets.length; i++ ) {
            if ( !/font-apex/i.test( sheets[ i ].href || "" ) ) {
                continue;
            }
            try {
                rules = sheets[ i ].cssRules;
            } catch ( e ) {
                continue;                   // cross-origin stylesheet
            }
            for ( j = 0; j < rules.length; j++ ) {
                if ( rules[ j ].selectorText ) {
                    namesFromCss( rules[ j ].selectorText, found );
                }
            }
        }
    }

    function namesFromFetch( found ) {
        var link = global.document.querySelector( 'link[rel="stylesheet"][href*="font-apex"]' );

        if ( !link || !global.fetch ) {
            return Promise.resolve();
        }

        return global.fetch( link.href )
            .then( function ( response ) {
                return response.ok ? response.text() : "";
            } )
            .then( function ( text ) {
                namesFromCss( text, found );
            } )
            .catch( function () {
                // blocked by CORS, offline, whatever - the bundled catalog still works
            } );
    }

    /**
     * Adds any icon the running APEX instance knows about but this build does not.
     * Resolves to true when the catalog changed.
     */
    function mergeRuntimeIcons() {
        if ( mergeAttempted ) {
            return Promise.resolve( false );
        }
        mergeAttempted = true;

        var found = Object.create( null );

        try {
            namesFromCssom( found );
        } catch ( e ) {
            // never let a stylesheet quirk stop the picker from opening
        }

        var next = Object.keys( found ).length
            ? Promise.resolve()
            : namesFromFetch( found );

        return next.then( function () {
            var known = Object.create( null ),
                extra = [];

            flatIcons().forEach( function ( icon ) {
                known[ icon.name ] = true;
            } );

            Object.keys( found ).forEach( function ( name ) {
                if ( !known[ name ] ) {
                    extra.push( { name: name } );
                }
            } );

            if ( !extra.length ) {
                return false;
            }

            extra.sort( function ( a, b ) {
                return a.name < b.name ? -1 : a.name > b.name ? 1 : 0;
            } );

            ip.icons.OTHER = ( ip.icons.OTHER || [] ).concat( extra );
            return true;
        } ).catch( function () {
            return false;
        } );
    }

    // ------------------------------------------------------------------
    // search
    //
    // Same ranking idea as 2.0, but the score lives in a local map instead of being written
    // onto the shared icon objects, so one search can no longer skew the next one.
    // ------------------------------------------------------------------

    function search( key ) {
        var ranked = [],
            score  = Object.create( null );

        flatIcons().forEach( function ( icon ) {
            var name    = icon.name.toUpperCase().slice( 3 ),   // drop the "fa-" prefix
                filters = icon.filters ? icon.filters.toUpperCase() : "",
                parts,
                rank    = 0;

            if ( name.indexOf( key ) >= 0 ) {
                parts = name.split( "-" );

                if ( name.indexOf( "-" ) < 0 ) {
                    rank += 1000;                               // single word
                }
                if ( name.length === key.length ) {
                    rank += 1000;                               // exact match
                }
                if ( parts[ 0 ].indexOf( key ) === 0 ) {
                    rank += 1000;                               // matches from the start
                }
                parts.forEach( function ( part ) {
                    if ( part && part.indexOf( key ) >= 0 ) {
                        rank += 100;
                    }
                } );

                score[ icon.name ] = rank;
                ranked.push( icon );
                return;
            }

            if ( filters.indexOf( key ) >= 0 ) {
                score[ icon.name ] = 1;
                ranked.push( icon );
            }
        } );

        ranked.sort( function ( a, b ) {
            return score[ b.name ] - score[ a.name ];
        } );

        return ranked;
    }

    // ------------------------------------------------------------------
    // rendering
    // ------------------------------------------------------------------

    function entryHtml( icon, showLabel ) {
        var name = escapeHtml( icon.name );

        return '<li class="a-IconPicker-listItem">'
            + '<button type="button" class="a-IconPicker-item" data-icon="' + name + '" title="' + name + '">'
            + '<span class="a-IconPicker-itemIcon fa ' + name + '" aria-hidden="true"></span>'
            + ( showLabel
                ? '<span class="a-IconPicker-itemLabel">' + name + "</span>"
                : '<span class="u-vh">' + name + "</span>" )
            + "</button>"
            + "</li>";
    }

    function listHtml( icons, showLabel ) {
        return '<ul class="a-IconPicker-list">'
            + icons.map( function ( icon ) {
                return entryHtml( icon, showLabel );
            } ).join( "" )
            + "</ul>";
    }

    function categoryHtml( title, icons, showLabel ) {
        return '<div class="a-IconPicker-category">'
            + '<h3 class="a-IconPicker-categoryTitle">' + escapeHtml( title ) + "</h3>"
            + listHtml( icons, showLabel )
            + "</div>";
    }

    function visibleCategories() {
        var all = Object.keys( ip.icons );

        return activeCategory === ALL_CHIP
            ? all
            : all.filter( function ( category ) {
                return category === activeCategory;
            } );
    }

    function renderGrid() {
        var showLabel = !activeTarget || activeTarget.options.showLabels !== false,
            key       = ( searchInput.value || "" ).toUpperCase().trim().replace( / /g, "-" ),
            html      = "";

        if ( key === "" ) {
            visibleCategories().forEach( function ( category ) {
                var icons = ip.icons[ category ].slice().sort( function ( a, b ) {
                    return a.name < b.name ? -1 : a.name > b.name ? 1 : 0;
                } );

                html += categoryHtml( categoryLabel( category ) + " Icons", icons, showLabel );
            } );
        } else {
            var pool = search( key );

            if ( activeCategory !== ALL_CHIP ) {
                var inCategory = Object.create( null );

                ip.icons[ activeCategory ].forEach( function ( icon ) {
                    inCategory[ icon.name ] = true;
                } );
                pool = pool.filter( function ( icon ) {
                    return inCategory[ icon.name ];
                } );
            }

            html = categoryHtml(
                pool.length ? pool.length + " Results" : "No results",
                pool,
                showLabel
            );
        }

        gridContainer.innerHTML = html;
        gridContainer.scrollTop = 0;
    }

    function renderChips() {
        var categories = Object.keys( ip.icons ),
            html;

        if ( !activeTarget || activeTarget.options.showCategories === false ) {
            chipContainer.hidden = true;
            chipContainer.innerHTML = "";
            return;
        }

        if ( categories.indexOf( activeCategory ) < 0 ) {
            activeCategory = ALL_CHIP;      // category disappeared, fall back to All
        }

        html = [ ALL_CHIP ].concat( categories ).map( function ( category ) {
            var isAll   = category === ALL_CHIP,
                label   = isAll ? ( activeTarget.options.allLabel || "All" ) : categoryLabel( category ),
                current = category === activeCategory;

            return '<button type="button" class="a-IconPicker-chip'
                + ( current ? " is-active" : "" )
                + '" data-category="' + escapeHtml( category ) + '"'
                + ' aria-pressed="' + ( current ? "true" : "false" ) + '">'
                + escapeHtml( label )
                + "</button>";
        } ).join( "" );

        chipContainer.hidden = false;
        chipContainer.innerHTML = html;
    }

    // ------------------------------------------------------------------
    // the dialog itself
    // ------------------------------------------------------------------

    function buildDialog() {
        var element = global.document.createElement( "dialog" );

        element.id = DIALOG_ID;
        element.className = "a-IconPicker";
        element.innerHTML =
            '<form method="dialog" class="a-IconPicker-form">'
                + '<div class="a-IconPicker-header">'
                    + '<h2 class="a-IconPicker-title"></h2>'
                    + '<button type="submit" class="a-IconPicker-dismiss" value="cancel">'
                        + '<span class="fa fa-times" aria-hidden="true"></span>'
                        + '<span class="u-vh">Close</span>'
                    + "</button>"
                + "</div>"
                + '<div class="a-IconPicker-toolbar">'
                    + '<div class="a-IconPicker-search">'
                        + '<span class="a-IconPicker-searchIcon fa fa-search" aria-hidden="true"></span>'
                        + '<label class="u-vh" for="' + DIALOG_ID + 'Search">Search</label>'
                        + '<input id="' + DIALOG_ID + 'Search" class="a-IconPicker-searchInput" type="search"'
                            + ' autocomplete="off" aria-controls="' + DIALOG_ID + 'Grid" />'
                    + "</div>"
                    + '<div class="a-IconPicker-size" role="group" aria-label="Icon size">'
                        + '<input type="radio" id="' + DIALOG_ID + 'Small" name="' + DIALOG_ID + 'Size" value="' + SIZE_SMALL + '" />'
                        + '<label for="' + DIALOG_ID + 'Small"></label>'
                        + '<input type="radio" id="' + DIALOG_ID + 'Large" name="' + DIALOG_ID + 'Size" value="' + SIZE_LARGE + '" />'
                        + '<label for="' + DIALOG_ID + 'Large"></label>'
                    + "</div>"
                + "</div>"
                + '<div class="a-IconPicker-chips" role="group" aria-label="Icon categories" hidden></div>'
                + '<div id="' + DIALOG_ID + 'Grid" class="a-IconPicker-grid" role="region" aria-live="polite"></div>'
                + '<div class="a-IconPicker-footer">'
                    + '<button type="submit" class="a-IconPicker-cancel t-Button" value="cancel"></button>'
                + "</div>"
            + "</form>";

        global.document.body.appendChild( element );
        return element;
    }

    function dialogElement() {
        if ( dialog$ ) {
            return dialog$;
        }

        dialog$       = buildDialog();
        titleElement  = dialog$.querySelector( ".a-IconPicker-title" );
        searchInput   = dialog$.querySelector( ".a-IconPicker-searchInput" );
        gridContainer = dialog$.querySelector( ".a-IconPicker-grid" );
        chipContainer = dialog$.querySelector( ".a-IconPicker-chips" );
        cancelButton  = dialog$.querySelector( ".a-IconPicker-cancel" );

        // one delegated listener for every icon in the grid - no inline handlers, no
        // javascript: URLs, nothing for a CSP to complain about
        gridContainer.addEventListener( "click", function ( event ) {
            var button = event.target.closest( ".a-IconPicker-item" );

            if ( button ) {
                choose( button.getAttribute( "data-icon" ) );
            }
        } );

        chipContainer.addEventListener( "click", function ( event ) {
            var chip = event.target.closest( ".a-IconPicker-chip" );

            if ( chip ) {
                activeCategory = chip.getAttribute( "data-category" );
                renderChips();
                renderGrid();
            }
        } );

        searchInput.addEventListener( "input", function () {
            global.clearTimeout( searchTimer );
            searchTimer = global.setTimeout( renderGrid, SEARCH_WAIT );
        } );

        // the dialog is a <form method="dialog"> so Enter would otherwise submit it, which
        // closes the picker the moment someone hits Enter after typing a search term
        searchInput.addEventListener( "keydown", function ( event ) {
            if ( event.key === "Enter" ) {
                event.preventDefault();
                global.clearTimeout( searchTimer );
                renderGrid();
            }
        } );

        dialog$.querySelectorAll( '.a-IconPicker-size input[type="radio"]' ).forEach( function ( radio ) {
            radio.addEventListener( "change", function () {
                storeSize( radio.value );
                applySize();
            } );
        } );

        // covers Esc, the close button and the cancel button in one place
        dialog$.addEventListener( "close", function () {
            activeTarget = null;

            if ( returnFocusTo && global.document.contains( returnFocusTo ) ) {
                returnFocusTo.focus();
            }
            returnFocusTo = null;
        } );

        return dialog$;
    }

    function applySize() {
        var large = storedSize() === SIZE_LARGE;

        dialog$.classList.toggle( "a-IconPicker--large", large );
        dialog$.querySelector( "#" + DIALOG_ID + ( large ? "Large" : "Small" ) ).checked = true;
    }

    function choose( iconName ) {
        if ( activeTarget ) {
            activeTarget.select( iconName );
        }
        dialog$.close( "picked" );
    }

    /**
     * @param {Object} target          what the picked icon should be applied to
     * @param {Object} target.options  plug-in attributes for the triggering item
     * @param {Function} target.select called with the chosen class name
     * @param {Element} [target.trigger] element focus returns to on close. Passed in rather
     *        than read from document.activeElement, which is not the button on every browser
     *        (Safari does not focus a button on click) nor on a programmatic click.
     */
    function open( target ) {
        var element = dialogElement(),
            options = target.options || {};

        activeTarget  = target;
        returnFocusTo = target.trigger || global.document.activeElement;

        titleElement.textContent = options.title || "Icon Picker";
        cancelButton.textContent = options.closeLabel || "Cancel";
        searchInput.placeholder  = options.placeholder || "";
        searchInput.value        = "";

        element.querySelector( 'label[for="' + DIALOG_ID + 'Small"]' ).textContent = options.smallLabel || "Small";
        element.querySelector( 'label[for="' + DIALOG_ID + 'Large"]' ).textContent = options.largeLabel || "Large";

        element.style.setProperty( "--a-ip-width", ( options.width || 600 ) + "px" );
        element.style.setProperty( "--a-ip-height", ( options.height || 800 ) + "px" );
        element.classList.toggle( "a-IconPicker--resizable", options.resizable !== false );

        applySize();
        renderChips();
        renderGrid();

        element.showModal();
        searchInput.focus();

        // pick up icons from a Font APEX newer than the bundled catalog, then redraw if we
        // actually found any. Deliberately after showModal so it never delays opening.
        mergeRuntimeIcons().then( function ( changed ) {
            if ( changed && element.open ) {
                renderChips();
                renderGrid();
            }
        } );
    }

    ip.open = open;

    // ------------------------------------------------------------------
    // page item
    // ------------------------------------------------------------------

    function pageItemIcon( itemName, value, fallback ) {
        var input = global.document.getElementById( itemName ),
            preview;

        if ( !input ) {
            return;
        }

        preview = input.parentNode.querySelector( "span.apex-item-icon" );

        if ( preview ) {
            preview.className = "apex-item-icon fa " + ( value || fallback || "" );
        }
    }

    /**
     * Wires up a page item rendered by the plug-in.
     *
     * The icon preview is refreshed from the item's own change event rather than by
     * overriding apex.item.create - that keeps the item a stock APEX text item, so dynamic
     * actions, validation and session state all behave exactly as they did in 2.0, while
     * apex.item( name ).setValue( ... ) still updates the preview because it fires change.
     */
    ip.attach = function ( itemName, options ) {
        var input  = global.document.getElementById( itemName ),
            button = global.document.getElementById( itemName + "_lov_btn" );

        if ( !input ) {
            return;
        }

        input.addEventListener( "change", function () {
            pageItemIcon( itemName, input.value, options.defaultIcon );
        } );

        if ( !button ) {
            return;                         // read-only or printer friendly
        }

        button.addEventListener( "click", function () {
            open( {
                trigger: button,
                options: options,
                select: function ( iconName ) {
                    if ( global.apex && global.apex.item ) {
                        global.apex.item( itemName ).setValue( iconName );
                    } else {
                        input.value = iconName;
                    }
                    pageItemIcon( itemName, iconName, options.defaultIcon );

                    var container = global.document.getElementById( itemName + "_CONTAINER" );

                    if ( container ) {
                        container.classList.add( "js-show-label" );
                    }
                }
            } );
        } );
    };

    // ------------------------------------------------------------------
    // interactive grid column
    // ------------------------------------------------------------------

    /**
     * Interactive Grid column. The apex.item.create contract here is the one from 2.0's
     * IPgrid.js - the grid depends on displayValueFor/setValue/enable/disable, so it is kept
     * as is; only the dialog wiring underneath it changed.
     */
    ip.attachGrid = function ( itemId, options ) {
        var index = 0,
            item$ = $( "#" + itemId ),
            defaultIcon = options.defaultIcon || "fa-navicon";

        item$.addClass( "u-vh is-focusable" );

        function render( full, value ) {
            var iconClass = value || defaultIcon,
                out = global.apex.util.htmlBuilder();

            out.markup( "<div" )
                .attr( "class", "ig-div-icon-picker" )
                .markup( "><button" )
                .attr( "id", itemId + "_lov_btn" )
                .attr( "type", "button" )
                .attr( "class", "t-Button t-Button--noLabel t-Button--icon ig-ip-render ig-button-icon-picker"
                    + ( options.showText ? "" : " ip-icon-only" ) )
                .markup( "><span" )
                .attr( "class", " ig-span-icon-picker fa " + iconClass )
                .attr( "aria-hidden", true )
                .optionalAttr( "disabled", options.readOnly )
                .markup( " /></button><input" )
                .attr( "type", "hidden" )
                .attr( "class", "ig-input-icon-picker" )
                .attr( "id", itemId + "_" + index + "_0" )
                .attr( "name", itemId + "_" + index )
                .attr( "value", iconClass )
                .attr( "tabindex", -1 )
                .optionalAttr( "disabled", options.readOnly )
                .markup( " /><label" )
                .attr( "for", itemId + "_" + index + "_0" )
                .markup( ">" )
                .content( options.showText ? iconClass : "" )
                .markup( "</label>" )
                .markup( " </div>" );

            index += 1;

            return out.toString();
        }

        function setGridValue( regionId, rowId, column, value ) {
            var widget = global.apex.region( regionId ).widget(),
                model  = widget.interactiveGrid( "getViews", "grid" ).model,
                fields = model.getOption( "fields" ),
                field  = "";

            Object.keys( fields ).forEach( function ( key ) {
                if ( fields[ key ].elementId === column ) {
                    field = key;
                }
            } );

            model.setRecordValue( rowId, field, value );
        }

        if ( !options.readOnly ) {
            // delegated, so buttons the grid renders later are covered too - 2.0 bound only
            // the buttons that happened to exist when the column was initialised
            if ( !boundGridColumns[ itemId ] ) {
                boundGridColumns[ itemId ] = true;

                $( global.document ).on( "click", 'button#' + itemId + '_lov_btn.ig-button-icon-picker', function ( event ) {
                    var button   = event.currentTarget,
                        input$   = $( button ).parent().find( "input.igiconpicker" ).first(),
                        rowId    = input$.closest( "tr" ).data( "id" ),
                        region$  = input$.parents( ".a-IG" ).first(),
                        regionId = ( region$.attr( "id" ) || "" ).slice( 0, -3 );

                    open( {
                        trigger: button,
                        options: options,
                        select: function ( iconName ) {
                            setGridValue( regionId, rowId, itemId, iconName );
                        }
                    } );
                } );
            }

            item$.closest( ".ig-button-icon-picker" ).prop( "disabled", true );
            item$.prop( "disabled", true );
        }

        global.apex.item.create( itemId, {
            setValue: function ( value ) {
                item$.val( value );
                item$.closest( "div.ig-div-icon-picker" )
                    .find( "span.ig-span-icon-picker" )
                    .attr( "class", "apex-item-icon ig-span-icon-picker fa " + ( value || defaultIcon ) );
            },
            disable: function () {
                item$.closest( ".ig-div-icon-picker" )
                    .removeClass( "ig-div-icon-picker-enabled" )
                    .addClass( "ig-div-icon-picker-disabled" );
                item$.closest( ".ig-button-icon-picker" ).prop( "disabled", true );
                item$.prop( "disabled", true );
            },
            enable: function () {
                if ( options.readOnly ) {
                    return;
                }
                item$.closest( ".ig-div-icon-picker" )
                    .removeClass( "ig-div-icon-picker-disabled" )
                    .addClass( "ig-div-icon-picker-enabled" );
                item$.closest( ".ig-button-icon-picker" ).prop( "disabled", false );
                item$.prop( "disabled", false );
            },
            displayValueFor: function ( value ) {
                return render( true, value );
            }
        } );
    };

} )( window, window.jQuery );
