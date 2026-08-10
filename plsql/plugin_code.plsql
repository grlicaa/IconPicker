--------------------------------------------------------------------------------
-- Icon Picker 3.0 - Oracle APEX item plug-in
-- https://github.com/grlicaa/IconPicker
--
-- This file is the plug-in's "PL/SQL Code" attribute. build/build.mjs embeds it into
-- plug-in/item_type_plugin_si_abakus_iconpicker_apex_232.sql, so edit it here, never
-- in the generated export.
--------------------------------------------------------------------------------

subtype gt_string is varchar2(32767);
subtype lt_string is varchar2(500);

--------------------------------------------------------------------------------
-- Helpers
--
-- Note: every apex_string.format call below passes p_max_length => 32767. The default is
-- 1000, which silently truncates - a long translated label or an item with several element
-- attributes is enough to cut generated markup or JavaScript in half.
--------------------------------------------------------------------------------

-- Renders a checkbox plug-in attribute as a JavaScript boolean.
function bool_attr (
    p_value   in varchar2,
    p_default in varchar2 default 'N' )
    return varchar2
is
begin
    return case when nvl( p_value, p_default ) = 'Y' then 'true' else 'false' end;
end bool_attr;

-- Resolves an item level override against the application wide setting. The item attribute
-- is a select list of DEFAULT / Y / N; DEFAULT (and null, for items saved before the
-- attribute existed) means "follow the application".
function override_attr (
    p_item_value   in varchar2,
    p_plugin_value in varchar2,
    p_default      in varchar2 )
    return varchar2
is
begin
    if p_item_value is null or p_item_value = 'DEFAULT' then
        return nvl( p_plugin_value, p_default );
    end if;

    return p_item_value;
end override_attr;

-- Dialog width/height are free text attributes, so anything non-numeric falls back to the
-- default rather than being pasted straight into the generated JavaScript.
function number_attr (
    p_value   in varchar2,
    p_default in number )
    return varchar2
is
begin
    return to_char( nvl( to_number( regexp_substr( p_value, '^\d{1,5}$' ) ), p_default ) );
end number_attr;

--------------------------------------------------------------------------------
-- Render Procedure
--------------------------------------------------------------------------------
procedure render (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result )
is
    -- Application level attributes
    l_button_hover        lt_string := p_plugin.attribute_01;
    l_button_close        lt_string := p_plugin.attribute_02;
    l_search_placeholder  lt_string := p_plugin.attribute_03;
    l_small_label         lt_string := p_plugin.attribute_04;
    l_large_label         lt_string := p_plugin.attribute_05;
    l_app_icon_labels     lt_string := p_plugin.attribute_06;
    -- attribute_07 was "Use Widget:IconList" in 2.0. The jQuery UI iconList widget no
    -- longer ships with APEX, so the attribute is gone and the slot is left unused.
    l_app_categories      lt_string := p_plugin.attribute_08;
    l_app_blacklist       gt_string := p_plugin.attribute_09;

    -- Component level attributes
    l_dialog_title        lt_string := nvl( p_item.attribute_01, 'Icon Picker' );
    l_dialog_resizable    lt_string := nvl( p_item.attribute_02, 'Y' );
    l_dialog_width        lt_string := number_attr( p_item.attribute_03, 600 );
    l_dialog_height       lt_string := number_attr( p_item.attribute_04, 800 );
    l_ig_default_icon     lt_string := nvl( p_item.attribute_05, 'fa-navicon' );
    l_ig_only_icon        lt_string := nvl( p_item.attribute_06, 'N' );
    l_ig_read_only        lt_string := nvl( p_item.attribute_07, 'N' );
    l_item_blacklist      gt_string := p_item.attribute_10;

    -- Resolved: the item wins unless it says "use application default"
    l_show_categories     lt_string := override_attr( p_item.attribute_08, l_app_categories,  'Y' );
    l_show_icon_labels    lt_string := override_attr( p_item.attribute_09, l_app_icon_labels, 'N' );

    -- Both lists always apply, so they are simply concatenated and split on the client
    l_blacklist           gt_string := rtrim( ltrim(
                              nvl( l_app_blacklist, '' ) || ',' || nvl( l_item_blacklist, '' ),
                              ',' ), ',' );

    l_component_type      lt_string := p_item.component_type_id;
    l_is_grid             boolean   := p_item.component_type_id = apex_component.c_comp_type_ig_column;
    l_is_editable         boolean   := not p_param.is_readonly and not p_param.is_printer_friendly;

    c_name       constant varchar2(30) := apex_plugin.get_input_name_for_item;

    l_value               gt_string := trim( p_param.value );
    l_options             gt_string;
    l_onload_code         gt_string;
begin

    apex_debug.info( 'Icon Picker: rendering %s (component type %s)', p_item.name, l_component_type );

    apex_plugin_util.debug_page_item (
        p_plugin    => p_plugin,
        p_page_item => p_item );

    -- Everything the client module needs, as one JSON object. apex_escape.js_literal
    -- quotes and escapes each value, so translated labels containing quotes or backslashes
    -- cannot break out of the generated JavaScript.
    l_options :=
        '{"title":'          || apex_escape.js_literal( l_dialog_title,       '"' ) ||
        ',"closeLabel":'     || apex_escape.js_literal( l_button_close,       '"' ) ||
        ',"placeholder":'    || apex_escape.js_literal( l_search_placeholder, '"' ) ||
        ',"smallLabel":'     || apex_escape.js_literal( l_small_label,        '"' ) ||
        ',"largeLabel":'     || apex_escape.js_literal( l_large_label,        '"' ) ||
        ',"defaultIcon":'    || apex_escape.js_literal( l_ig_default_icon,    '"' ) ||
        ',"blacklist":'      || apex_escape.js_literal( l_blacklist,          '"' ) ||
        ',"showLabels":'     || bool_attr( l_show_icon_labels, 'N' ) ||
        ',"showCategories":' || bool_attr( l_show_categories,  'Y' ) ||
        ',"resizable":'      || bool_attr( l_dialog_resizable, 'Y' ) ||
        ',"width":'          || l_dialog_width ||
        ',"height":'         || l_dialog_height ||
        ',"showText":'       || case when l_ig_only_icon = 'Y' then 'false' else 'true' end ||
        ',"readOnly":'       || bool_attr( l_ig_read_only, 'N' ) ||
        '}';

    if l_is_grid then

        if not l_is_editable then

            apex_plugin_util.print_hidden_if_readonly (
                p_item_name           => p_item.name,
                p_value               => p_param.value,
                p_is_readonly         => p_param.is_readonly,
                p_is_printer_friendly => p_param.is_printer_friendly );

        else

            -- Must stay in step with render() in src/js/iconpicker.js, which produces the
            -- same markup for rows the Interactive Grid draws on the client.
            sys.htp.prn(
                apex_string.format(
                    '<div class="ig-div-icon-picker"><button id="%s_lov_btn" type="button" ' ||
                    'class="t-Button t-Button--noLabel t-Button--icon ig-button-icon-picker %s" %s>' ||
                    '<span class="ig-span-icon-picker fa %s" aria-hidden="true"></span></button>' ||
                    '<input %s type="%s" value="%s" %s /></div>'
                    , apex_escape.html_attribute( p_item.name )
                    , case when l_ig_only_icon = 'Y' then 'ip-icon-only' end
                    , case when l_ig_read_only = 'Y' then 'disabled' end
                    , apex_escape.html_attribute( nvl( l_value, l_ig_default_icon ) )
                    , apex_plugin_util.get_element_attributes( p_item, c_name, 'apex-item-text igiconpicker apex-item-plugin' )
                    , case when l_ig_only_icon = 'Y' then 'hidden' else 'text' end
                    , apex_escape.html_attribute( l_value )
                    , case when l_ig_read_only = 'Y' then 'disabled' end
                    , p_max_length => 32767 ) );

            l_onload_code := l_onload_code || apex_string.format(
                'abakusIconPicker.attachGrid(%s,%s);',
                apex_escape.js_literal( p_item.name, '"' ),
                l_options,
                p_max_length => 32767 );

        end if;

        p_result.is_navigable := l_is_editable;

    else

        sys.htp.prn(
            apex_string.format(
                '<input type="text" %s value="%s" %s />'
                  -- c_name, not p_item.name: get_input_name_for_item returns the p_t0n
                  -- form field name APEX expects on submit. 2.0 emitted the item name
                  -- here instead. get_element_attributes also handles placeholder, size,
                  -- maxlength and custom element attributes, all properly escaped.
                , apex_plugin_util.get_element_attributes(
                      p_item          => p_item,
                      p_name          => c_name,
                      p_default_class => 'text_field apex-item-text' ||
                          case when p_item.icon_css_classes is not null then ' apex-item-has-icon' end )
                , apex_escape.html_attribute( l_value )
                , case when p_param.is_readonly then 'disabled="disabled"' end
                , p_max_length => 32767 ) );

        if p_item.icon_css_classes is not null then
            sys.htp.prn(
                apex_string.format(
                    '<span class="apex-item-icon fa %s" aria-hidden="true"></span>'
                    , apex_escape.html_attribute( nvl( l_value, p_item.icon_css_classes ) )
                    , p_max_length => 32767 ) );
        end if;

        if l_is_editable then
            sys.htp.prn(
                apex_string.format(
                    '<button type="button" class="a-Button a-Button--popupLOV ip-button-popup" id="%s_lov_btn">' ||
                    '<span class="a-Icon icon-popup-lov" aria-hidden="true"></span>' ||
                    '<span class="u-vh">%s</span></button>'
                    , apex_escape.html_attribute( p_item.name )
                    , apex_escape.html( l_button_hover )
                    , p_max_length => 32767 ) );
        end if;

        l_onload_code := l_onload_code || apex_string.format(
            'abakusIconPicker.attach(%s,%s);',
            apex_escape.js_literal( p_item.name, '"' ),
            l_options,
            p_max_length => 32767 );

    end if;

    if l_onload_code is not null then
        apex_javascript.add_onload_code( p_code => l_onload_code );
    end if;

    apex_debug.info( 'Icon Picker: finished %s', p_item.name );

end render;

--------------------------------------------------------------------------------
-- Meta Data Procedure
--------------------------------------------------------------------------------
procedure metadata_ig_icon_picker (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_meta_data_param,
    p_result in out nocopy apex_plugin.t_item_meta_data_result )
is
begin
    p_result.escape_output := false;
end metadata_ig_icon_picker;
