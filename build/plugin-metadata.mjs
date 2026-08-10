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
        prompt: 'Show icons labels', type: 'CHECKBOX', required: false,
        default: 'Y', components: BOTH, translatable: false,
        help: [ 'Show the icon class name underneath each icon in the dialog. Default = Yes.' ]
    },
    // Sequence 7 was "Use Widget:IconList" in 2.0. jQuery UI's iconList widget no longer
    // ships with APEX, so the attribute is dropped and the slot deliberately left empty.
    {
        id: '208817364821553001', scope: 'APPLICATION', sequence: 8, display: 70,
        prompt: 'Show category filter', type: 'CHECKBOX', required: false,
        default: 'Y', components: BOTH, translatable: false,
        help: [
            'Show a row of category chips above the icon grid (All, New, AI, Web application, ',
            'Country flag, ...) so users can narrow a 1500+ icon list down to one category.<br>',
            'Default = Yes.'
        ]
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
