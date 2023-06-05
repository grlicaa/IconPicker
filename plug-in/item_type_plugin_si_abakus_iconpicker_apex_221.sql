prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_220100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.7'
,p_default_workspace_id=>2303530563576685
,p_default_application_id=>216
,p_default_id_offset=>131865714620687320
,p_default_owner=>'IGRALNICA'
);
end;
/
 
prompt APPLICATION 216 - Icon Picker [Plug-in]
--
-- Application Export:
--   Application:     216
--   Name:            Icon Picker [Plug-in]
--   Date and Time:   11:29 Monday June 5, 2023
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 208808430900605280
--   Manifest End
--   Version:         22.1.7
--   Instance ID:     713433240898444
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/si_abakus_iconpicker
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(208808430900605280)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'SI.ABAKUS.ICONPICKER'
,p_display_name=>'IconPicker'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#js/IPicons.min.js',
'#PLUGIN_FILES#js/IPdoc.min.js',
'#PLUGIN_FILES#js/IPgrid.min.js',
''))
,p_css_file_urls=>'#PLUGIN_FILES#css/IPui.min.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- GLOBAL',
'subtype gt_string is varchar2(32767);',
'subtype lt_string is varchar2(500);',
'',
'procedure render (',
'    p_item   in            apex_plugin.t_item,',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_param  in            apex_plugin.t_item_render_param,',
'    p_result in out nocopy apex_plugin.t_item_render_result )',
'is',
'  -- Application components ',
'  l_dialog_button_hover     lt_string := p_plugin.attribute_01;',
'  l_dialog_button_close     lt_string := p_plugin.attribute_02;',
'  l_dialog_search_placeh    lt_string := p_plugin.attribute_03;',
'  l_dialog_small_label      lt_string := p_plugin.attribute_04;',
'  l_dialog_large_label      lt_string := p_plugin.attribute_05;',
'  l_dialog_show_icon_label  lt_string := p_plugin.attribute_06;',
'  l_dialog_useIconList      lt_string := p_plugin.attribute_07;',
'  ',
'  -- Item componens',
'  l_dialog_title            lt_string := nvl(p_item.attribute_01,''Icon Picker'');',
'  l_dialog_resizable        lt_string := nvl(p_item.attribute_02,''Y'');',
'  l_dialog_width            lt_string := nvl(p_item.attribute_03,''600'');  ',
'  l_dialog_height           lt_string := nvl(p_item.attribute_04,''800'');',
'  l_ig_def_icon             lt_string := nvl(p_item.attribute_05,''fa-navicon'');',
'  l_ig_only_icon            lt_string := nvl(p_item.attribute_06,''N'');',
'  l_ig_read_only            lt_string := nvl(p_item.attribute_07,''N'');',
'  ',
'  -- Component type',
'  l_component_type lt_string := p_item.component_type_id;',
'  l_comp_type_ig_column lt_string := apex_component.c_comp_type_ig_column;',
'  l_comp_type_page_item lt_string := apex_component.c_comp_type_page_item; ',
'    ',
'  c_name            constant varchar2(30)    := apex_plugin.get_input_name_for_item;',
'  ',
'  l_dialog_name varchar2(30) := ''IconPickerDialogBox''; --Static in IPdoc.js',
'  l_onload_code gt_string := '''';',
'begin',
'',
'   apex_debug.info(''plugin ''||p_item.name||'' started'');',
'   apex_debug.info(''l_component_type ''||l_component_type);',
'   apex_debug.info(''l_comp_type_ig_column ''||l_comp_type_ig_column);',
'   apex_debug.info(''l_comp_type_page_item ''||l_comp_type_page_item);',
'   apex_plugin_util.debug_page_item (',
'    p_plugin    => p_plugin,',
'    p_page_item => p_item );',
'    ',
' ',
'    if l_component_type = l_comp_type_ig_column then -- interactive grid',
'        apex_debug.info(''item is in IG '');',
'        if p_param.is_readonly or p_param.is_printer_friendly then',
'            apex_debug.info(''is_readonly  or is_printer_friendly'');',
'            ',
'            apex_plugin_util.print_hidden_if_readonly (',
'              p_item_name           => p_item.name,',
'              p_value               => p_param.value,',
'              p_is_readonly         => p_param.is_readonly,',
'              p_is_printer_friendly => p_param.is_printer_friendly',
'            );',
'        else',
'            apex_debug.info(''not READONLY or PRINTERFRENDLY'');',
'           ',
'            sys.htp.prn(',
'                apex_string.format(',
'                    ''<div class="ig-div-icon-picker"><button id="%s_lov_btn" type="button" class="t-Button t-Button--noLabel t-Button--icon ig-button-icon-picker %s" %s><span class="ig-span-icon-picker fa %s" aria-hidden="true"></span></button><input'
||' %s id="%s"  type="%s" value="%s" %s /></div>''',
'                    , p_item.name',
'                    , case when l_ig_only_icon = ''Y'' then ''ip-icon-only'' else '''' end',
'                    , case when l_ig_read_only = ''Y'' then ''disabled'' else '''' end',
'                    , nvl( case when p_param.value is null then '''' else ltrim( rtrim ( apex_escape.html_attribute(p_param.value) ) ) end,''fa-navicon'')',
'                    , apex_plugin_util.get_element_attributes(p_item, c_name, ''apex-item-text igiconpicker apex-item-plugin'')',
'                    , p_item.name',
'                    , case when l_ig_only_icon = ''Y'' then ''hidden'' else ''text'' end',
'                    , case when p_param.value is null then '''' else ltrim( rtrim ( apex_escape.html_attribute(p_param.value) ) ) end',
'                    , case when l_ig_read_only = ''Y'' then ''disabled'' else '''' end',
'                 )',
'             );',
'',
'            l_onload_code := l_onload_code||',
'                apex_string.format(',
'                  ''IPinit("%s", {readOnly: %s, isRequired: %s, defIcon:"%s", showText:%s, pDWidth:"%s", pDHeight:"%s", pDTitle:"%s",pReszie:%s, pIconLabels:%s, pDplaceholder:"%s", pDsmall:"%s", pDlarge:"%s"});''',
'                  , case when p_param.is_readonly or p_param.is_printer_friendly then p_item.name || ''_DISPLAY'' else p_item.name end',
'                  , case when l_ig_read_only = ''Y'' then ''true'' else ''false'' end',
'                  , case when p_item.is_required then ''true'' else ''false'' end',
'                  , l_ig_def_icon',
'                  , case when l_ig_only_icon = ''Y'' then ''false'' else ''true'' end',
'                  , l_dialog_width',
'                  , l_dialog_height',
'                  , l_dialog_title',
'                  , case when l_dialog_resizable = ''Y'' then ''true'' else ''false'' end    ',
'                  , case when l_dialog_show_icon_label  = ''Y'' then ''true'' else ''false'' end ',
'                  , l_dialog_search_placeh',
'                  , l_dialog_small_label',
'                  , l_dialog_large_label  ',
'                                    ',
'                );   ',
'                ',
'        end if;',
'        ',
'           ',
'        p_result.is_navigable := (not p_param.is_readonly = false and not p_param.is_printer_friendly);',
'    ',
'    else  --normal page item',
'	',
'		sys.htp.prn(',
'			apex_string.format(',
'				''<input type="text" id="%s" name="%s" placeholder="%s" class="%s" value="%s" size="%s" maxlength="%s" %s />''',
'				,p_item.name',
'				,p_item.name',
'				,p_item.placeholder',
'				,''text_field apex-item-text ''||p_item.element_css_classes|| case when p_item.icon_css_classes is not null then '' apex-item-has-icon'' else null end',
'				,case when p_item.escape_output then sys.htf.escape_sc(p_param.value) else p_param.value end',
'				,nvl(p_item.element_width,30)',
'				,p_item.element_max_length',
'				,case when p_param.is_readonly then ''disabled="disabled" '' else '''' end',
'			)',
'        );',
'        -- Add icon Yes/No      ',
'        if p_item.icon_css_classes is not null then',
'		    sys.htp.prn(',
'				apex_string.format(',
'					''<span class="apex-item-icon fa %s" aria-hidden="true"></span>''',
'					,nvl(p_param.value,p_item.icon_css_classes)',
'				)',
'			);',
'       end if;    ',
'',
'        if not p_param.is_readonly and not p_param.is_printer_friendly then',
'		    sys.htp.prn(',
'				apex_string.format(',
'					''<button type="button" class="a-Button a-Button--popupLOV" id="%s_lov_btn"><span class="a-Icon icon-popup-lov"><span class="visuallyhidden">%s</span></span></button>''',
'					,p_item.name',
'					,l_dialog_button_hover',
'				)',
'			);	   ',
'',
'            l_onload_code := l_onload_code|| ',
'				apex_string.format(',
'						''$( "input#%s" ).change(function () {',
'							setElementIcon("%s", $(this).val());',
'						});''',
'						,p_item.name',
'						,p_item.name',
'				);              ',
'            ',
'			l_onload_code := l_onload_code|| ',
'				apex_string.format(',
'						''$( "button#%s_lov_btn" ).click(function () {',
'								$("#%s").dialog("option", "modalItem", false)',
'										.dialog("option", "width", %s)',
'										.dialog("option", "height", %s)',
'										.dialog("option", "title", "%s")',
'										.dialog("option", "resizable", %s)',
'                                        .dialog("option", "showIconLabel", %s)',
'										.dialog("option", "tirggElem", "%s")',
'										.html(''''<main class="dm-Body"><div class="dm-Container"><div class="dm-SearchBox"><label class="dm-AccessibleHidden" for="search">Search</label><div class="dm-SearchBox-wrap"><span class="dm-SearchBox-icon fa fa-search" aria-hidden="true"><'
||'/span><input id="search" class="dm-SearchBox-input" type="search" placeholder="%s" aria-controls="icons" /></div><div class="dm-SearchBox-settings"><div class="dm-RadioPillSet dm-RadioPillSet--large" role="group" aria-label="Icon Size"><div class="dm'
||'-RadioPillSet-option"><input type="radio" id="icon_size_small" name="icon_size" value="SMALL"><label for="icon_size_small">%s</label></div><div class="dm-RadioPillSet-option"><input type="radio" id="icon_size_large" name="icon_size" value="LARGE"><la'
||'bel for="icon_size_large">%s</label></div></div></div></div><div id="icons" class="dm-Search" role="region" aria-live="polite"></div></div></main>'''')',
'										.dialog("open");',
'						});''				',
'						,p_item.name',
'						,l_dialog_name',
'						,l_dialog_width',
'						,l_dialog_height',
'						,l_dialog_title',
'						,case when l_dialog_resizable = ''Y'' then ''true'' else ''false'' end  ',
'                        ,case when l_dialog_show_icon_label  = ''Y'' then ''true'' else ''false'' end ',
'						,p_item.name',
'                        ,l_dialog_search_placeh',
'                        ,l_dialog_small_label',
'                        ,l_dialog_large_label',
'				);',
'              ',
'        end if;    ',
'    end if;       ',
'    ',
'    if not p_param.is_readonly and not p_param.is_printer_friendly then',
'      ',
'		l_onload_code := l_onload_code|| ',
'			apex_string.format(',
'					''loadIconPickerDialog("%s", %s);''				',
'					,l_dialog_button_close',
'                    ,case when l_dialog_useIconList  = ''Y'' then ''true'' else ''false'' end  ',
'			);		',
'            ',
'',
'    end if;',
'   ',
'    apex_javascript.add_onload_code (p_code => l_onload_code);',
'   ',
'    apex_debug.info(''plugin ''||p_item.name||'' ended'');',
'   ',
'',
'end;',
'',
'--------------------------------------------------------------------------------',
'-- Meta Data Procedure',
'--------------------------------------------------------------------------------',
'procedure metadata_ig_icon_picker (',
'  p_item   in            apex_plugin.t_item,',
'  p_plugin in            apex_plugin.t_plugin,',
'  p_param  in            apex_plugin.t_item_meta_data_param,',
'  p_result in out nocopy apex_plugin.t_item_meta_data_result )',
'is',
'begin',
'  p_result.escape_output := false;',
'end metadata_ig_icon_picker;',
''))
,p_api_version=>2
,p_render_function=>'render'
,p_meta_data_function=>'metadata_ig_icon_picker'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:ESCAPE_OUTPUT:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:PLACEHOLDER:ICON'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'2.0'
,p_about_url=>'https://github.com/grlicaa/IconPicker'
,p_files_version=>37
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208810565561615940)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Dialog button hover title'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Open list of Icons'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>true
,p_help_text=>'On hover Icon Picker link, display title "Open list of Icons". (This is for easy translation to other languages.)'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208811250930618571)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Dialog cancel button text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Cancel'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>true
,p_help_text=>'On dialog windows, "Cancel" button title. (This is for easy translation to other languages.)'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208811752451621111)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Dialog search field placeholder'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Search icons...'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>true
,p_help_text=>'Used for placeholder on popUP dialog page...'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208812329671625019)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'SMALL icons label'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Small'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>true
,p_help_text=>'For smaller icons Button label'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208812819427627608)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'LARGE icons label'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Large'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>true
,p_help_text=>'For larger icons Button label'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208813336271629981)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Show icons labels'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'Show in dialog box icons labels... by default = YES'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(194653929594946896)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Use Widget:IconList'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Use <a href="https://docs.oracle.com/en/database/oracle/application-express/18.2/aexjs/iconList.html">Widget:IconList</a><br>',
'If library don''t exists or something is wrong with it, use of this library can be disabled here !'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208813781871632529)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Dialog title'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Icon Picker'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>true
,p_help_text=>'Dialog title, default value "Icon Picker"'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208814261077635845)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Dialog re-sizable'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'Dialog re-sizable Yes/No'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208814795746638855)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Dialog width'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'600'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Dialog weight<br>',
'option for dialog weight'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208815269054640707)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Dialog height'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'800'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Dialog height<br>',
'option for dialog height'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208815776816643180)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'IG default icon'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_default_value=>'fa-navicon'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'IG default icon is used as default null value button, for opening Pop up List of Icons.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208816314668649692)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'IG only icon'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IG only icon<br>',
'option decide if input filed is shown in interactive grid. <br>',
'Yes = Displays only icon<br>',
'No = Displays text input and icon<br>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(208816790769651776)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'IG Read Only'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '76617220666F6E74617065783D666F6E74617065787C7C7B7D3B66756E6374696F6E20736574456C656D656E7449636F6E28705F6E616D652C705F76616C297B242822696E70757423222B705F6E616D652B222E617065782D6974656D2D6861732D6963';
wwv_flow_imp.g_varchar2_table(2) := '6F6E22292E706172656E74282264697622292E66696E6428227370616E2E617065782D6974656D2D69636F6E22292E617474722822636C617373222C22617065782D6974656D2D69636F6E20666120222B705F76616C297D66756E6374696F6E20736574';
wwv_flow_imp.g_varchar2_table(3) := '456C656D656E7456616C756528705F6E616D652C705F76616C297B242822696E70757423222B705F6E616D65292E76616C28705F76616C292C24282223222B705F6E616D652B225F434F4E5441494E455222292E616464436C61737328226A732D73686F';
wwv_flow_imp.g_varchar2_table(4) := '772D6C6162656C22292C736574456C656D656E7449636F6E28705F6E616D652C705F76616C297D66756E6374696F6E207365744947456C656D656E7456616C756528705F726567696F6E49642C705F726F7749642C705F636F6C756D6E2C705F76616C29';
wwv_flow_imp.g_varchar2_table(5) := '7B636F6E7374207769646765743D617065782E726567696F6E28705F726567696F6E4964292E77696467657428292C677269643D7769646765742E696E7465726163746976654772696428226765745669657773222C226772696422292C6D6F64656C3D';
wwv_flow_imp.g_varchar2_table(6) := '677269642E6D6F64656C2C6669656C64733D7769646765742E696E746572616374697665477269642822676574566965777322292E677269642E6D6F64656C2E6765744F7074696F6E28226669656C647322293B6C6574206669656C643D22223B666F72';
wwv_flow_imp.g_varchar2_table(7) := '2876617220656C20696E206669656C6473296669656C64735B656C5D2E656C656D656E7449643D3D3D705F636F6C756D6E2626286669656C643D656C293B6D6F64656C2E7365745265636F726456616C756528705F726F7749642C6669656C642C705F76';
wwv_flow_imp.g_varchar2_table(8) := '616C297D66756E6374696F6E20636C6F73654469616C6F6749502869735F677269642C705F6469616C6F672C705F726567696F6E49642C705F726F7749642C705F636F6C756D6E2C705F76616C297B69735F677269643F282428222349636F6E5069636B';
wwv_flow_imp.g_varchar2_table(9) := '65724469616C6F67426F7822292E6469616C6F672822636C6F736522292C7365744947456C656D656E7456616C756528705F726567696F6E49642C705F726F7749642C705F636F6C756D6E2C705F76616C29293A28736574456C656D656E7456616C7565';
wwv_flow_imp.g_varchar2_table(10) := '28705F6469616C6F672C705F76616C292C2428222349636F6E5069636B65724469616C6F67426F7822292E6469616C6F672822636C6F73652229297D66756E6374696F6E206164644974656D4C69737428704974656D4C697374297B2428704974656D4C';
wwv_flow_imp.g_varchar2_table(11) := '697374292E65616368282866756E6374696F6E28297B7472797B242874686973292E69636F6E4C697374287B6D756C7469706C653A21312C6E617669676174696F6E3A21302C6974656D53656C6563746F723A21317D297D636174636828657272297B63';
wwv_flow_imp.g_varchar2_table(12) := '6F6E736F6C652E6C6F67286572722E6D657373616765297D7D29297D66756E6374696F6E206C6F616449636F6E5069636B65724469616C6F67287044436C6F7365422C7055736549636F6E4C697374297B242822626F647922292E617070656E6428273C';
wwv_flow_imp.g_varchar2_table(13) := '6469762069643D2249636F6E5069636B65724469616C6F67426F78223E3C2F6469763E27292C2428222349636F6E5069636B65724469616C6F67426F7822292E6469616C6F67287B6D6F64616C3A21302C7469746C653A2249636F6E205069636B657222';
wwv_flow_imp.g_varchar2_table(14) := '2C6175746F4F70656E3A21312C726573697A61626C653A21302C77696474683A3630302C6865696768743A3830302C636C6F73654F6E4573636170653A21302C7469726767456C656D3A22222C74697267674974656D3A7B7D2C73686F7749636F6E4C61';
wwv_flow_imp.g_varchar2_table(15) := '62656C3A21302C6D6F64616C4974656D3A21312C75736549636F6E4C6973743A7055736549636F6E4C6973742C6F70656E3A66756E6374696F6E28297B77696E646F772E6164644576656E744C697374656E657228226B6579646F776E222C2866756E63';
wwv_flow_imp.g_varchar2_table(16) := '74696F6E286576656E74297B5B33372C33382C33392C34305D2E696E6465784F66286576656E742E6B6579436F6465293E2D3126266576656E742E70726576656E7444656661756C7428297D29292C696E697449636F6E7328666F6E74617065782C2428';
wwv_flow_imp.g_varchar2_table(17) := '74686973292E6469616C6F6728226F7074696F6E222C227469726767456C656D22292C242874686973292E6469616C6F6728226F7074696F6E222C2274697267674974656D22292C7B69735F677269643A242874686973292E6469616C6F6728226F7074';
wwv_flow_imp.g_varchar2_table(18) := '696F6E222C226D6F64616C4974656D22292C73686F7749636F6E4C6162656C3A242874686973292E6469616C6F6728226F7074696F6E222C2273686F7749636F6E4C6162656C22292C75736549636F6E4C6973743A242874686973292E6469616C6F6728';
wwv_flow_imp.g_varchar2_table(19) := '226F7074696F6E222C2275736549636F6E4C69737422297D297D2C636C6F73653A66756E6374696F6E28297B2428226D61696E2E646D2D426F647922292E72656D6F766528297D2C63616E63656C3A66756E6374696F6E28297B2428226D61696E2E646D';
wwv_flow_imp.g_varchar2_table(20) := '2D426F647922292E72656D6F766528297D2C627574746F6E733A5B7B746578743A7044436C6F7365422C636C69636B3A66756E6374696F6E28297B242874686973292E6469616C6F672822636C6F736522297D7D5D7D297D66756E6374696F6E20696E69';
wwv_flow_imp.g_varchar2_table(21) := '7449636F6E732866612C705F6469616C6F672C705F6974656D2C704F7074297B76617220243D66612E242C4C3D224C41524745222C533D22534D414C4C222C49544D3D705F6974656D7C7C7B726567696F6E49643A22222C726F7749643A22222C636F6C';
wwv_flow_imp.g_varchar2_table(22) := '756D6E3A22227D2C434C5F4C415247453D22666F7263652D66612D6C67222C774C6F636174696F6E2C63757272656E7449636F6E3D77696E646F772E6C6F636174696F6E2E686173682E7265706C616365282223222C2222297C7C2266612D6170657822';
wwv_flow_imp.g_varchar2_table(23) := '2C69734C617267652C74696D656F75742C6170657849636F6E732C6170657849636F6E4B6579732C666C617474656E65643D5B5D2C69636F6E73243D2428222369636F6E7322292C5F69734C617267653D66756E6374696F6E2876616C7565297B696628';
wwv_flow_imp.g_varchar2_table(24) := '76616C7565297472797B6C6F63616C53746F726167652E7365744974656D28226C617267652E666F6E7461706578222C76616C7565297D63617463682865297B69734C617267653D76616C75657D656C7365207472797B72657475726E206C6F63616C53';
wwv_flow_imp.g_varchar2_table(25) := '746F726167652E6765744974656D28226C617267652E666F6E746170657822297C7C2266616C7365227D63617463682865297B72657475726E2069734C617267657C7C2869734C617267653D2266616C736522297D7D2C69735072657669657750616765';
wwv_flow_imp.g_varchar2_table(26) := '2C686967686C696768743D66756E6374696F6E287478742C737472297B72657475726E207478742E7265706C616365286E657720526567457870282228222B7374722B2229222C22676922292C273C7370616E20636C6173733D22686967686C69676874';
wwv_flow_imp.g_varchar2_table(27) := '223E24313C2F7370616E3E27297D2C72656E64657249636F6E733D66756E6374696F6E286F707473297B766172206F75747075743B636C65617254696D656F75742874696D656F7574293B766172206465626F756E63653D6F7074732E6465626F756E63';
wwv_flow_imp.g_varchar2_table(28) := '657C7C35302C6B65793D6F7074732E66696C746572537472696E677C7C22222C6B65794C656E6774683D6B65792E6C656E6774683B6B65793D6B65792E746F55707065724361736528292E7472696D28293B76617220617373656D626C6548544D4C3D66';
wwv_flow_imp.g_varchar2_table(29) := '756E6374696F6E28726573756C745365742C69636F6E43617465676F7279297B7661722073697A653D2274727565223D3D3D5F69734C6172676528293F4C3A532C676574456E7472793D66756E6374696F6E28636C297B72657475726E273C6C6920726F';
wwv_flow_imp.g_varchar2_table(30) := '6C653D226E617669676174696F6E223E3C6120636C6173733D22646D2D5365617263682D726573756C742220687265663D226A6176617363726970743A636C6F73654469616C6F67495028272B704F70742E69735F677269642B222C27222B705F646961';
wwv_flow_imp.g_varchar2_table(31) := '6C6F672B22272C27222B49544D2E726567696F6E49642B22272C27222B49544D2E726F7749642B22272C27222B49544D2E636F6C756D6E2B22272C27222B636C2B275C27293B2220617269612D6C6162656C6C656462793D2269706C697374223E3C6469';
wwv_flow_imp.g_varchar2_table(32) := '7620636C6173733D22646D2D5365617263682D69636F6E223E3C7370616E20636C6173733D22742D49636F6E20666120272B636C2B272220617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F6469763E272B28704F70742E73686F77';
wwv_flow_imp.g_varchar2_table(33) := '49636F6E4C6162656C3F273C64697620636C6173733D22646D2D5365617263682D696E666F223E3C7370616E20636C6173733D22646D2D5365617263682D636C617373223E272B636C2B223C2F7370616E3E3C2F6469763E223A2222292B223C2F613E3C';
wwv_flow_imp.g_varchar2_table(34) := '2F6C693E227D3B69636F6E43617465676F72793F286F75747075743D286F75747075742B3D273C64697620636C6173733D22646D2D5365617263682D63617465676F7279223E27292B273C683220636C6173733D22646D2D5365617263682D7469746C65';
wwv_flow_imp.g_varchar2_table(35) := '223E272B69636F6E43617465676F72792E7265706C616365282F5F2F672C222022292E746F4C6F7765724361736528292B222049636F6E733C2F68323E222C6F75747075742B3D273C756C20636C6173733D22646D2D5365617263682D6C697374222069';
wwv_flow_imp.g_varchar2_table(36) := '643D2269706C697374223E272C726573756C745365742E666F7245616368282866756E6374696F6E2869636F6E436C617373297B6F75747075742B3D676574456E7472792869636F6E436C6173732E6E616D65297D29292C6F75747075742B3D223C2F75';
wwv_flow_imp.g_varchar2_table(37) := '6C3E222C6F75747075742B3D223C2F6469763E22293A726573756C745365742E6C656E6774683E302626726573756C745365742E666F7245616368282866756E6374696F6E2869636F6E436C617373297B6F75747075742B3D676574456E747279286963';
wwv_flow_imp.g_varchar2_table(38) := '6F6E436C6173732E6E616D65297D29297D2C7365617263683D66756E6374696F6E28297B69662831213D3D6B65792E6C656E677468297B76617220726573756C745365743D5B5D2C726573756C74735469746C653D22223B6F75747075743D22222C2222';
wwv_flow_imp.g_varchar2_table(39) := '3D3D3D6B65793F6170657849636F6E4B6579732E666F7245616368282866756E6374696F6E2869636F6E43617465676F7279297B726573756C745365743D6170657849636F6E735B69636F6E43617465676F72795D2E736F7274282866756E6374696F6E';
wwv_flow_imp.g_varchar2_table(40) := '28612C62297B72657475726E20612E6E616D653C622E6E616D653F2D313A612E6E616D653E622E6E616D653F313A307D29292C617373656D626C6548544D4C28726573756C745365742C69636F6E43617465676F7279297D29293A2828726573756C7453';
wwv_flow_imp.g_varchar2_table(41) := '65743D666C617474656E65642E66696C746572282866756E6374696F6E2863757256616C297B766172206E616D653D63757256616C2E6E616D652E746F55707065724361736528292E736C6963652833292C6E616D654172722C66696C746572733D6375';
wwv_flow_imp.g_varchar2_table(42) := '7256616C2E66696C746572733F63757256616C2E66696C746572732E746F55707065724361736528293A22222C66696C746572734172722C6669727374586C6574746572732C72616E6B3D302C692C66696C7465724172724C656E2C6A2C6E616D654172';
wwv_flow_imp.g_varchar2_table(43) := '724C656E3B6966286B65792E696E6465784F6628222022293E302626286B65793D6B65792E7265706C616365282220222C222D2229292C6E616D652E696E6465784F66286B6579293E3D30297B666F72286E616D654172724C656E3D286E616D65417272';
wwv_flow_imp.g_varchar2_table(44) := '3D6E616D652E73706C697428222D2229292E6C656E6774682C6E616D652E696E6465784F6628222D22293C3026262872616E6B2B3D316533292C6E616D652E6C656E6774683D3D3D6B65794C656E67746826262872616E6B2B3D316533292C2866697273';
wwv_flow_imp.g_varchar2_table(45) := '74586C6574746572733D6E616D654172725B305D2E736C69636528302C6B65794C656E67746829292E696E6465784F66286B6579293E3D3026262872616E6B2B3D316533292C6A3D303B6A3C6E616D654172724C656E3B6A2B2B296E616D654172725B6A';
wwv_flow_imp.g_varchar2_table(46) := '5D26266E616D654172725B6A5D2E696E6465784F66286B6579293E3D3026262872616E6B2B3D313030293B72657475726E2063757256616C2E72616E6B3D72616E6B2C21307D666F722866696C7465724172724C656E3D2866696C746572734172723D66';
wwv_flow_imp.g_varchar2_table(47) := '696C746572732E73706C697428222C2229292E6C656E6774682C693D303B693C66696C7465724172724C656E3B692B2B29696628286669727374586C6574746572733D66696C746572734172725B695D2E736C69636528302C6B65794C656E6774682929';
wwv_flow_imp.g_varchar2_table(48) := '2E696E6465784F66286B6579293E3D302972657475726E2063757256616C2E72616E6B3D312C21307D2929292E736F7274282866756E6374696F6E28612C62297B7661722061723D612E72616E6B2C62723D622E72616E6B3B72657475726E2061723E62';
wwv_flow_imp.g_varchar2_table(49) := '723F2D313A61723C62723F313A307D29292C617373656D626C6548544D4C28726573756C74536574292C726573756C74735469746C653D303D3D3D726573756C745365742E6C656E6774683F224E6F20726573756C7473223A726573756C745365742E6C';
wwv_flow_imp.g_varchar2_table(50) := '656E6774682B2220526573756C7473222C6F75747075743D273C64697620636C6173733D22646D2D5365617263682D63617465676F7279223E3C683220636C6173733D22646D2D5365617263682D7469746C65223E272B726573756C74735469746C652B';
wwv_flow_imp.g_varchar2_table(51) := '273C2F68323E3C756C20636C6173733D22646D2D5365617263682D6C697374222069643D2269706C697374223E272B6F75747075742B223C2F756C3E222C6F75747075742B3D223C2F6469763E22292C646F63756D656E742E676574456C656D656E7442';
wwv_flow_imp.g_varchar2_table(52) := '794964282269636F6E7322292E696E6E657248544D4C3D6F75747075747D7D3B74696D656F75743D73657454696D656F7574282866756E6374696F6E28297B73656172636828292C704F70742E75736549636F6E4C69737426266164644974656D4C6973';
wwv_flow_imp.g_varchar2_table(53) := '742822756C2369706C69737422297D292C6465626F756E6365297D2C746F67676C6553697A653D66756E6374696F6E28746861742C6166666563746564297B746861742E636865636B65643D21302C746861742E76616C75653D3D3D4C3F286166666563';
wwv_flow_imp.g_varchar2_table(54) := '7465642E616464436C61737328434C5F4C41524745292C5F69734C617267652822747275652229293A2861666665637465642E72656D6F7665436C61737328434C5F4C41524745292C5F69734C61726765282266616C73652229297D2C646F776E6C6F64';
wwv_flow_imp.g_varchar2_table(55) := '53564742746E3D66756E6374696F6E28297B242822627574746F6E2E70762D427574746F6E22292E6F6E2822636C69636B222C2866756E6374696F6E28297B7661722073697A653D2274727565223D3D3D5F69734C6172676528293F4C2E746F4C6F7765';
wwv_flow_imp.g_varchar2_table(56) := '724361736528293A532E746F4C6F7765724361736528293B77696E646F772E6F70656E28222E2E2F737667732F222B73697A652B222F222B63757272656E7449636F6E2E7265706C616365282266612D222C2222292B222E73766722297D29297D2C7365';
wwv_flow_imp.g_varchar2_table(57) := '743B2866756E6374696F6E28297B72657475726E202428222369636F6E5F7072657669657722292E6C656E6774683E307D2928293F282274727565223D3D3D5F69734C6172676528293F28646F63756D656E742E676574456C656D656E74427949642822';
wwv_flow_imp.g_varchar2_table(58) := '69636F6E5F73697A655F6C6172676522292E636865636B65643D21302C69636F6E73242E616464436C61737328434C5F4C4152474529293A28646F63756D656E742E676574456C656D656E7442794964282269636F6E5F73697A655F736D616C6C22292E';
wwv_flow_imp.g_varchar2_table(59) := '636865636B65643D21302C69636F6E73242E72656D6F7665436C61737328434C5F4C4152474529292C63757272656E7449636F6E2626282428222E646D2D49636F6E2D6E616D6522292E746578742863757272656E7449636F6E292C2428225B64617461';
wwv_flow_imp.g_varchar2_table(60) := '2D69636F6E5D22292E72656D6F7665436C617373282266612D6170657822292E616464436C6173732863757272656E7449636F6E292C72656E64657249636F6E5072657669657728292C646F776E6C6F6453564742746E2829292C242822696E7075742C';
wwv_flow_imp.g_varchar2_table(61) := '2073656C65637422292E6F6E28226368616E6765222C2866756E6374696F6E28297B72656E64657249636F6E5072657669657728297D2929293A282274727565223D3D3D5F69734C6172676528293F28646F63756D656E742E676574456C656D656E7442';
wwv_flow_imp.g_varchar2_table(62) := '794964282269636F6E5F73697A655F6C6172676522292E636865636B65643D21302C69636F6E73242E616464436C61737328434C5F4C4152474529293A28646F63756D656E742E676574456C656D656E7442794964282269636F6E5F73697A655F736D61';
wwv_flow_imp.g_varchar2_table(63) := '6C6C22292E636865636B65643D21302C69636F6E73242E72656D6F7665436C61737328434C5F4C4152474529292C66612E69636F6E7326262872656E64657249636F6E73287B7D292C7365743D5B5D2C6170657849636F6E733D66612E69636F6E732C28';
wwv_flow_imp.g_varchar2_table(64) := '6170657849636F6E4B6579733D4F626A6563742E6B657973286170657849636F6E7329292E666F7245616368282866756E6374696F6E2869636F6E43617465676F7279297B7365743D7365742E636F6E636174286170657849636F6E735B69636F6E4361';
wwv_flow_imp.g_varchar2_table(65) := '7465676F72795D297D29292C666C617474656E65643D7365742C2428222373656172636822292E6F6E28226B65797570222C2866756E6374696F6E2865297B72656E64657249636F6E73287B6465626F756E63653A3235302C66696C746572537472696E';
wwv_flow_imp.g_varchar2_table(66) := '673A652E7461726765742E76616C75657D297D29292C2428275B6E616D653D2269636F6E5F73697A65225D27292E6F6E2822636C69636B222C2866756E6374696F6E2865297B766172206166666563746564456C656D3D69636F6E73242E6C656E677468';
wwv_flow_imp.g_varchar2_table(67) := '3E303F69636F6E73243A2428222E646D2D49636F6E5072657669657722293B746F67676C6553697A6528746869732C6166666563746564456C656D297D292929297D4E6F64654C6973742E70726F746F747970652E666F72456163687C7C284E6F64654C';
wwv_flow_imp.g_varchar2_table(68) := '6973742E70726F746F747970652E666F72456163683D41727261792E70726F746F747970652E666F7245616368292C666F6E74617065782E243D66756E6374696F6E2873656C6563746F72297B7661722053656C3D66756E6374696F6E2873656C656374';
wwv_flow_imp.g_varchar2_table(69) := '6F72297B7661722073656C65637465643D5B5D3B72657475726E22737472696E67223D3D747970656F662073656C6563746F723F73656C65637465643D646F63756D656E742E717565727953656C6563746F72416C6C2873656C6563746F72293A73656C';
wwv_flow_imp.g_varchar2_table(70) := '65637465642E707573682873656C6563746F72292C746869732E656C656D656E74733D73656C65637465642C746869732E6C656E6774683D746869732E656C656D656E74732E6C656E6774682C746869737D3B72657475726E2053656C2E70726F746F74';
wwv_flow_imp.g_varchar2_table(71) := '7970653D7B616464436C6173733A66756E6374696F6E28636C297B766172207374722C636C61737341727261793D636C2E7265706C616365282F202B283F3D20292F672C2222292E73706C697428222022293B72657475726E20746869732E656C656D65';
wwv_flow_imp.g_varchar2_table(72) := '6E74732E666F7245616368282866756E6374696F6E28656C656D297B636C61737341727261792E666F7245616368282866756E6374696F6E2863297B632626656C656D2E636C6173734C6973742E6164642863297D29297D29292C746869737D2C72656D';
wwv_flow_imp.g_varchar2_table(73) := '6F7665436C6173733A66756E6374696F6E28636C297B7661722072656D6F7665416C6C436C61737365732C72656D6F76654F6E65436C6173732C616374696F6E3D636C3F66756E6374696F6E28656C297B656C2E636C6173734C6973742E72656D6F7665';
wwv_flow_imp.g_varchar2_table(74) := '28636C297D3A66756E6374696F6E28656C297B656C2E636C6173734E616D653D22227D3B72657475726E20746869732E656C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B616374696F6E28656C656D297D29292C746869';
wwv_flow_imp.g_varchar2_table(75) := '737D2C676574436C6173733A66756E6374696F6E28297B72657475726E20746869732E656C656D656E74735B305D2E636C6173734C6973742E76616C75657D2C6F6E3A66756E6374696F6E286576656E744E616D652C66756E63297B72657475726E2074';
wwv_flow_imp.g_varchar2_table(76) := '6869732E656C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B656C656D2E6164644576656E744C697374656E6572286576656E744E616D652C66756E63297D29292C746869737D2C76616C3A66756E6374696F6E28297B76';
wwv_flow_imp.g_varchar2_table(77) := '61722076616C3D22223B72657475726E20746869732E656C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B73776974636828656C656D2E6E6F64654E616D65297B6361736522494E505554223A656C656D2E636865636B65';
wwv_flow_imp.g_varchar2_table(78) := '6426262876616C3D656C656D2E76616C7565293B627265616B3B636173652253454C454354223A76616C3D656C656D2E6F7074696F6E735B656C656D2E73656C6563746564496E6465785D2E76616C75657D7D29292C76616C7D2C746578743A66756E63';
wwv_flow_imp.g_varchar2_table(79) := '74696F6E2874297B72657475726E20742626746869732E656C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B656C656D2E74657874436F6E74656E743D747D29292C746869737D2C68746D6C3A66756E6374696F6E286829';
wwv_flow_imp.g_varchar2_table(80) := '7B7661722068746D6C3B72657475726E22737472696E67223D3D747970656F6620683F28746869732E656C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B656C656D2E696E6E657248544D4C3D687D29292C74686973293A';
wwv_flow_imp.g_varchar2_table(81) := '28746869732E656C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B68746D6C3D656C656D2E696E6E657248544D4C7D29292C68746D6C297D2C706172656E743A66756E6374696F6E28297B76617220703B72657475726E20';
wwv_flow_imp.g_varchar2_table(82) := '746869732E656C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B703D6E65772053656C28656C656D2E706172656E744E6F6465297D29292C707D2C686964653A66756E6374696F6E28297B72657475726E20746869732E65';
wwv_flow_imp.g_varchar2_table(83) := '6C656D656E74732E666F7245616368282866756E6374696F6E28656C656D297B656C656D2E7374796C652E646973706C61793D226E6F6E65227D29292C746869737D2C73686F773A66756E6374696F6E2874297B72657475726E20746869732E656C656D';
wwv_flow_imp.g_varchar2_table(84) := '656E74732E666F7245616368282866756E6374696F6E28656C656D297B656C656D2E7374796C652E646973706C61793D6E756C6C7D29292C746869737D7D2C6E65772053656C2873656C6563746F72297D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(132674631230225860)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_file_name=>'js/IPdoc.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '66756E6374696F6E204950696E6974286974656D49642C6F7074297B76617220696E6465783D303B636F6E7374206974656D243D24282223222B6974656D4964292C7372243D6974656D242E616464436C6173732822752D76682069732D666F63757361';
wwv_flow_imp.g_varchar2_table(2) := '626C6522292E706172656E7428293B66756E6374696F6E2072656E6465722866756C6C2C76616C7565297B76617220705F76616C3D76616C75657C7C2266612D6E617669636F6E223B636F6E7374206F75743D617065782E7574696C2E68746D6C427569';
wwv_flow_imp.g_varchar2_table(3) := '6C64657228293B72657475726E206F75742E6D61726B757028223C64697622292E617474722822636C617373222C2269672D6469762D69636F6E2D7069636B657222292E6D61726B757028223E3C627574746F6E22292E6174747228226964222C697465';
wwv_flow_imp.g_varchar2_table(4) := '6D49642B225F6C6F765F62746E22292E61747472282274797065222C22627574746F6E22292E617474722822636C617373222C22742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E2069672D69702D';
wwv_flow_imp.g_varchar2_table(5) := '72656E6465722069672D627574746F6E2D69636F6E2D7069636B6572222B286F70742E73686F77546578743F22223A222069702D69636F6E2D6F6E6C792229292E6D61726B757028223E3C7370616E22292E617474722822636C617373222C222069672D';
wwv_flow_imp.g_varchar2_table(6) := '7370616E2D69636F6E2D7069636B657220666120222B705F76616C292E617474722822617269612D68696464656E222C2130292E6F7074696F6E616C41747472282264697361626C6564222C6F70742E726561644F6E6C79292E6D61726B75702822202F';
wwv_flow_imp.g_varchar2_table(7) := '3E3C2F627574746F6E3E3C696E70757422292E61747472282274797065222C2268696464656E22292E617474722822636C617373222C2269672D696E7075742D69636F6E2D7069636B657222292E6174747228226964222C6974656D49642B225F222B69';
wwv_flow_imp.g_varchar2_table(8) := '6E6465782B225F3022292E6174747228226E616D65222C6974656D49642B225F222B696E646578292E61747472282276616C7565222C705F76616C292E617474722822746162696E646578222C2D31292E6F7074696F6E616C4174747228226469736162';
wwv_flow_imp.g_varchar2_table(9) := '6C6564222C6F70742E726561644F6E6C79292E6D61726B75702822202F3E3C6C6162656C22292E617474722822666F72222C6974656D49642B225F222B696E6465782B225F3022292E6D61726B757028223E22292E636F6E74656E74286F70742E73686F';
wwv_flow_imp.g_varchar2_table(10) := '77546578743F705F76616C3A2222292E6D61726B757028223C2F6C6162656C3E22292E6D61726B75702822203C2F6469763E22292C696E6465782B3D312C6F75742E746F537472696E6728297D66756E6374696F6E20617474616368427574746F6E636C';
wwv_flow_imp.g_varchar2_table(11) := '69636B28297B242827627574746F6E5B69643D22272B6974656D49642B275F6C6F765F62746E225D2E69672D627574746F6E2D69636F6E2D7069636B657227292E65616368282866756E6374696F6E28692C65297B242865292E6F6E2822636C69636B22';
wwv_flow_imp.g_varchar2_table(12) := '2C2866756E6374696F6E286B297B636F6E737420696E707574243D242865292E706172656E7428292E66696E642822696E7075742E696769636F6E7069636B65723A666972737422292C726F7749643D696E707574242E636C6F73657374282274722229';
wwv_flow_imp.g_varchar2_table(13) := '2E646174612822696422292C726567696F6E49643D2428696E707574242E706172656E747328222E612D49472229292E617474722822696422292E736C69636528302C2D33293B2428222349636F6E5069636B65724469616C6F67426F7822292E646961';
wwv_flow_imp.g_varchar2_table(14) := '6C6F6728226F7074696F6E222C226D6F64616C4974656D222C2130292E6469616C6F6728226F7074696F6E222C227769647468222C6F70742E70445769647468292E6469616C6F6728226F7074696F6E222C22686569676874222C6F70742E7044486569';
wwv_flow_imp.g_varchar2_table(15) := '676874292E6469616C6F6728226F7074696F6E222C227469746C65222C6F70742E70445469746C65292E6469616C6F6728226F7074696F6E222C22726573697A61626C65222C6F70742E705265737A6965292E6469616C6F6728226F7074696F6E222C22';
wwv_flow_imp.g_varchar2_table(16) := '7469726767456C656D222C6974656D4964292E6469616C6F6728226F7074696F6E222C2273686F7749636F6E4C6162656C222C6F70742E7049636F6E4C6162656C73292E6469616C6F6728226F7074696F6E222C2274697267674974656D222C7B726567';
wwv_flow_imp.g_varchar2_table(17) := '696F6E49643A726567696F6E49642C726F7749643A726F7749642C636F6C756D6E3A6974656D49647D292E68746D6C28273C6D61696E20636C6173733D22646D2D426F6479223E3C64697620636C6173733D22646D2D436F6E7461696E6572223E3C6469';
wwv_flow_imp.g_varchar2_table(18) := '7620636C6173733D22646D2D536561726368426F78223E3C6C6162656C20636C6173733D22646D2D41636365737369626C6548696464656E2220666F723D22736561726368223E5365617263683C2F6C6162656C3E3C64697620636C6173733D22646D2D';
wwv_flow_imp.g_varchar2_table(19) := '536561726368426F782D77726170223E3C7370616E20636C6173733D22646D2D536561726368426F782D69636F6E2066612066612D7365617263682220617269612D68696464656E3D2274727565223E3C2F7370616E3E3C696E7075742069643D227365';
wwv_flow_imp.g_varchar2_table(20) := '617263682220636C6173733D22646D2D536561726368426F782D696E7075742220747970653D227365617263682220706C616365686F6C6465723D22272B6F70742E7044706C616365686F6C6465722B272220617269612D636F6E74726F6C733D226963';
wwv_flow_imp.g_varchar2_table(21) := '6F6E7322202F3E3C2F6469763E3C64697620636C6173733D22646D2D536561726368426F782D73657474696E6773223E3C64697620636C6173733D22646D2D526164696F50696C6C53657420646D2D526164696F50696C6C5365742D2D6C617267652220';
wwv_flow_imp.g_varchar2_table(22) := '726F6C653D2267726F75702220617269612D6C6162656C3D2249636F6E2053697A65223E3C64697620636C6173733D22646D2D526164696F50696C6C5365742D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2269636F6E';
wwv_flow_imp.g_varchar2_table(23) := '5F73697A655F736D616C6C22206E616D653D2269636F6E5F73697A65222076616C75653D22534D414C4C223E3C6C6162656C20666F723D2269636F6E5F73697A655F736D616C6C223E272B6F70742E7044736D616C6C2B273C2F6C6162656C3E3C2F6469';
wwv_flow_imp.g_varchar2_table(24) := '763E3C64697620636C6173733D22646D2D526164696F50696C6C5365742D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2269636F6E5F73697A655F6C6172676522206E616D653D2269636F6E5F73697A65222076616C75';
wwv_flow_imp.g_varchar2_table(25) := '653D224C41524745223E3C6C6162656C20666F723D2269636F6E5F73697A655F6C61726765223E272B6F70742E70446C617267652B273C2F6C6162656C3E3C2F6469763E3C2F6469763E3C2F6469763E3C2F6469763E3C6469762069643D2269636F6E73';
wwv_flow_imp.g_varchar2_table(26) := '2220636C6173733D22646D2D5365617263682220726F6C653D22726567696F6E2220617269612D6C6976653D22706F6C697465223E3C2F6469763E3C2F6469763E3C2F6D61696E3E27292E6469616C6F6728226F70656E22297D29297D29297D6F70742E';
wwv_flow_imp.g_varchar2_table(27) := '726561644F6E6C797C7C28617474616368427574746F6E636C69636B28292C6974656D242E636C6F7365737428222E69672D627574746F6E2D69636F6E2D7069636B657222292E70726F70282264697361626C6564222C2130292C6974656D242E70726F';
wwv_flow_imp.g_varchar2_table(28) := '70282264697361626C6564222C213029292C617065782E6974656D2E637265617465286974656D49642C7B73657456616C75653A66756E6374696F6E2876616C7565297B6974656D242E76616C2876616C7565292C76616C75653F6974656D242E636C6F';
wwv_flow_imp.g_varchar2_table(29) := '7365737428226469762E69672D6469762D69636F6E2D7069636B657222292E66696E6428227370616E2E69672D7370616E2D69636F6E2D7069636B657222292E617474722822636C617373222C22617065782D6974656D2D69636F6E2069672D7370616E';
wwv_flow_imp.g_varchar2_table(30) := '2D69636F6E2D7069636B657220666120222B76616C7565293A6974656D242E636C6F7365737428226469762E69672D6469762D69636F6E2D7069636B657222292E66696E6428227370616E2E69672D7370616E2D69636F6E2D7069636B657222292E6174';
wwv_flow_imp.g_varchar2_table(31) := '74722822636C617373222C22617065782D6974656D2D69636F6E2069672D7370616E2D69636F6E2D7069636B657220666120222B6F70742E64656649636F6E297D2C64697361626C653A66756E6374696F6E28297B6974656D242E636C6F736573742822';
wwv_flow_imp.g_varchar2_table(32) := '2E69672D6469762D69636F6E2D7069636B657222292E72656D6F7665436C617373282269672D6469762D69636F6E2D7069636B65722D656E61626C656422292C6974656D242E636C6F7365737428222E69672D6469762D69636F6E2D7069636B65722229';
wwv_flow_imp.g_varchar2_table(33) := '2E616464436C617373282269672D6469762D69636F6E2D7069636B65722D64697361626C656422292C6974656D242E636C6F7365737428222E69672D627574746F6E2D69636F6E2D7069636B657222292E70726F70282264697361626C6564222C213029';
wwv_flow_imp.g_varchar2_table(34) := '2C6974656D242E70726F70282264697361626C6564222C2130297D2C656E61626C653A66756E6374696F6E28297B6F70742E726561644F6E6C797C7C286974656D242E636C6F7365737428222E69672D6469762D69636F6E2D7069636B657222292E7265';
wwv_flow_imp.g_varchar2_table(35) := '6D6F7665436C617373282269672D6469762D69636F6E2D7069636B65722D64697361626C656422292C6974656D242E636C6F7365737428222E69672D6469762D69636F6E2D7069636B657222292E616464436C617373282269672D6469762D69636F6E2D';
wwv_flow_imp.g_varchar2_table(36) := '7069636B65722D656E61626C656422292C6974656D242E636C6F7365737428222E69672D627574746F6E2D69636F6E2D7069636B657222292E70726F70282264697361626C6564222C2131292C6974656D242E70726F70282264697361626C6564222C21';
wwv_flow_imp.g_varchar2_table(37) := '3129297D2C646973706C617956616C7565466F723A66756E6374696F6E2876616C7565297B72657475726E2072656E6465722821302C76616C7565297D7D297D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(132674951662225862)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_file_name=>'js/IPgrid.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '76617220666F6E74617065783D7B69636F6E733A7B5745425F4150504C49434154494F4E3A5B7B6E616D653A2266612D616464726573732D626F6F6B222C66696C746572733A22636F6E7461637473227D2C7B6E616D653A2266612D616464726573732D';
wwv_flow_imp.g_varchar2_table(2) := '626F6F6B2D6F222C66696C746572733A22636F6E7461637473227D2C7B6E616D653A2266612D616464726573732D63617264222C66696C746572733A227663617264227D2C7B6E616D653A2266612D616464726573732D636172642D6F222C66696C7465';
wwv_flow_imp.g_varchar2_table(3) := '72733A2276636172642D6F227D2C7B6E616D653A2266612D61646A757374222C66696C746572733A22636F6E7472617374227D2C7B6E616D653A2266612D616C657274222C66696C746572733A226D6573736167652C636F6D6D656E74227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(4) := '653A2266612D616D65726963616E2D7369676E2D6C616E67756167652D696E74657270726574696E67227D2C7B6E616D653A2266612D616E63686F72222C66696C746572733A226C696E6B227D2C7B6E616D653A2266612D61706578222C66696C746572';
wwv_flow_imp.g_varchar2_table(5) := '733A226170706C69636174696F6E657870726573732C68746D6C64622C7765626462227D2C7B6E616D653A2266612D617065782D737175617265222C66696C746572733A226170706C69636174696F6E657870726573732C68746D6C64622C7765626462';
wwv_flow_imp.g_varchar2_table(6) := '227D2C7B6E616D653A2266612D61726368697665222C66696C746572733A22626F782C73746F72616765227D2C7B6E616D653A2266612D617265612D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(7) := '2266612D6172726F7773222C66696C746572733A226D6F76652C72656F726465722C726573697A65227D2C7B6E616D653A2266612D6172726F77732D68222C66696C746572733A22726573697A65227D2C7B6E616D653A2266612D6172726F77732D7622';
wwv_flow_imp.g_varchar2_table(8) := '2C66696C746572733A22726573697A65227D2C7B6E616D653A2266612D61736C2D696E74657270726574696E67227D2C7B6E616D653A2266612D6173736973746976652D6C697374656E696E672D73797374656D73227D2C7B6E616D653A2266612D6173';
wwv_flow_imp.g_varchar2_table(9) := '74657269736B222C66696C746572733A2264657461696C73227D2C7B6E616D653A2266612D6174227D2C7B6E616D653A2266612D617564696F2D6465736372697074696F6E227D2C7B6E616D653A2266612D62616467652D6C697374227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(10) := '3A2266612D626164676573227D2C7B6E616D653A2266612D62616C616E63652D7363616C65227D2C7B6E616D653A2266612D62616E222C66696C746572733A2264656C6574652C72656D6F76652C74726173682C686964652C626C6F636B2C73746F702C';
wwv_flow_imp.g_varchar2_table(11) := '61626F72742C63616E63656C227D2C7B6E616D653A2266612D6261722D6368617274222C66696C746572733A2262617263686172746F2C67726170682C616E616C7974696373227D2C7B6E616D653A2266612D626172636F6465222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(12) := '227363616E227D2C7B6E616D653A2266612D62617273222C66696C746572733A226E617669636F6E2C72656F726465722C6D656E752C647261672C72656F726465722C73657474696E67732C6C6973742C756C2C6F6C2C636865636B6C6973742C746F64';
wwv_flow_imp.g_varchar2_table(13) := '6F2C6C6973742C68616D627572676572227D2C7B6E616D653A2266612D62617468222C66696C746572733A2262617468747562227D2C7B6E616D653A2266612D626174746572792D30222C66696C746572733A22656D707479227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(14) := '612D626174746572792D31222C66696C746572733A2271756172746572227D2C7B6E616D653A2266612D626174746572792D32222C66696C746572733A2268616C66227D2C7B6E616D653A2266612D626174746572792D33222C66696C746572733A2274';
wwv_flow_imp.g_varchar2_table(15) := '68726565207175617274657273227D2C7B6E616D653A2266612D626174746572792D34222C66696C746572733A2266756C6C227D2C7B6E616D653A2266612D626174746C6573686970227D2C7B6E616D653A2266612D626564222C66696C746572733A22';
wwv_flow_imp.g_varchar2_table(16) := '74726176656C2C686F74656C227D2C7B6E616D653A2266612D62656572222C66696C746572733A22616C636F686F6C2C737465696E2C6472696E6B2C6D75672C6261722C6C6971756F72227D2C7B6E616D653A2266612D62656C6C222C66696C74657273';
wwv_flow_imp.g_varchar2_table(17) := '3A22616C6572742C72656D696E6465722C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D62656C6C2D6F222C66696C746572733A22616C6572742C72656D696E6465722C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D62';
wwv_flow_imp.g_varchar2_table(18) := '656C6C2D736C617368227D2C7B6E616D653A2266612D62656C6C2D736C6173682D6F227D2C7B6E616D653A2266612D62696379636C65222C66696C746572733A2276656869636C652C62696B65227D2C7B6E616D653A2266612D62696E6F63756C617273';
wwv_flow_imp.g_varchar2_table(19) := '227D2C7B6E616D653A2266612D62697274686461792D63616B65227D2C7B6E616D653A2266612D626C696E64227D2C7B6E616D653A2266612D626F6C74222C66696C746572733A226C696768746E696E672C776561746865722C666C617368227D2C7B6E';
wwv_flow_imp.g_varchar2_table(20) := '616D653A2266612D626F6D62227D2C7B6E616D653A2266612D626F6F6B222C66696C746572733A22726561642C646F63756D656E746174696F6E227D2C7B6E616D653A2266612D626F6F6B6D61726B222C66696C746572733A2273617665227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(21) := '6D653A2266612D626F6F6B6D61726B2D6F222C66696C746572733A2273617665227D2C7B6E616D653A2266612D627261696C6C65227D2C7B6E616D653A2266612D62726561646372756D62222C66696C746572733A226E617669676174696F6E227D2C7B';
wwv_flow_imp.g_varchar2_table(22) := '6E616D653A2266612D627269656663617365222C66696C746572733A22776F726B2C627573696E6573732C6F66666963652C6C7567676167652C626167227D2C7B6E616D653A2266612D627567222C66696C746572733A227265706F72742C696E736563';
wwv_flow_imp.g_varchar2_table(23) := '74227D2C7B6E616D653A2266612D6275696C64696E67222C66696C746572733A22776F726B2C627573696E6573732C61706172746D656E742C6F66666963652C636F6D70616E79227D2C7B6E616D653A2266612D6275696C64696E672D6F222C66696C74';
wwv_flow_imp.g_varchar2_table(24) := '6572733A22776F726B2C627573696E6573732C61706172746D656E742C6F66666963652C636F6D70616E79227D2C7B6E616D653A2266612D62756C6C686F726E222C66696C746572733A22616E6E6F756E63656D656E742C73686172652C62726F616463';
wwv_flow_imp.g_varchar2_table(25) := '6173742C6C6F75646572227D2C7B6E616D653A2266612D62756C6C73657965222C66696C746572733A22746172676574227D2C7B6E616D653A2266612D627573222C66696C746572733A2276656869636C65227D2C7B6E616D653A2266612D627574746F';
wwv_flow_imp.g_varchar2_table(26) := '6E227D2C7B6E616D653A2266612D627574746F6E2D636F6E7461696E6572222C66696C746572733A22726567696F6E227D2C7B6E616D653A2266612D627574746F6E2D67726F7570222C66696C746572733A2270696C6C227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(27) := '63616C63756C61746F72227D2C7B6E616D653A2266612D63616C656E646172222C66696C746572733A22646174652C74696D652C7768656E227D2C7B6E616D653A2266612D63616C656E6461722D636865636B2D6F227D2C7B6E616D653A2266612D6361';
wwv_flow_imp.g_varchar2_table(28) := '6C656E6461722D6D696E75732D6F227D2C7B6E616D653A2266612D63616C656E6461722D6F222C66696C746572733A22646174652C74696D652C7768656E227D2C7B6E616D653A2266612D63616C656E6461722D706C75732D6F227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(29) := '66612D63616C656E6461722D74696D65732D6F227D2C7B6E616D653A2266612D63616D657261222C66696C746572733A2270686F746F2C706963747572652C7265636F7264227D2C7B6E616D653A2266612D63616D6572612D726574726F222C66696C74';
wwv_flow_imp.g_varchar2_table(30) := '6572733A2270686F746F2C706963747572652C7265636F7264227D2C7B6E616D653A2266612D636172222C66696C746572733A226175746F6D6F62696C652C76656869636C65227D2C7B6E616D653A2266612D6361726473222C66696C746572733A2262';
wwv_flow_imp.g_varchar2_table(31) := '6C6F636B73227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D646F776E222C66696C746572733A22746F67676C65646F776E2C6D6F72652C64726F70646F776E2C6D656E75227D2C7B6E616D653A2266612D63617265742D73717561';
wwv_flow_imp.g_varchar2_table(32) := '72652D6F2D6C656674222C66696C746572733A2270726576696F75732C6261636B2C746F67676C656C656674227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D7269676874222C66696C746572733A226E6578742C666F7277617264';
wwv_flow_imp.g_varchar2_table(33) := '2C746F67676C657269676874227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D7570222C66696C746572733A22746F67676C657570227D2C7B6E616D653A2266612D6361726F7573656C222C66696C746572733A22736C6964657368';
wwv_flow_imp.g_varchar2_table(34) := '6F77227D2C7B6E616D653A2266612D636172742D6172726F772D646F776E222C66696C746572733A2273686F7070696E67227D2C7B6E616D653A2266612D636172742D6172726F772D7570227D2C7B6E616D653A2266612D636172742D636865636B227D';
wwv_flow_imp.g_varchar2_table(35) := '2C7B6E616D653A2266612D636172742D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D636172742D656D707479227D2C7B6E616D653A2266612D636172742D66756C6C227D2C7B6E616D653A2266612D636172742D';
wwv_flow_imp.g_varchar2_table(36) := '6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D636172742D6C6F636B227D2C7B6E616D653A2266612D636172742D6D61676E696679696E672D676C617373227D2C7B6E616D653A2266612D6361';
wwv_flow_imp.g_varchar2_table(37) := '72742D706C7573222C66696C746572733A226164642C73686F7070696E67227D2C7B6E616D653A2266612D636172742D74696D6573227D2C7B6E616D653A2266612D6363227D2C7B6E616D653A2266612D6365727469666963617465222C66696C746572';
wwv_flow_imp.g_varchar2_table(38) := '733A2262616467652C73746172227D2C7B6E616D653A2266612D6368616E67652D63617365222C66696C746572733A226C6F776572636173652C757070657263617365227D2C7B6E616D653A2266612D636865636B222C66696C746572733A2263686563';
wwv_flow_imp.g_varchar2_table(39) := '6B6D61726B2C646F6E652C746F646F2C61677265652C6163636570742C636F6E6669726D2C7469636B227D2C7B6E616D653A2266612D636865636B2D636972636C65222C66696C746572733A22746F646F2C646F6E652C61677265652C6163636570742C';
wwv_flow_imp.g_varchar2_table(40) := '636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D636972636C652D6F222C66696C746572733A22746F646F2C646F6E652C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D737175617265';
wwv_flow_imp.g_varchar2_table(41) := '222C66696C746572733A22636865636B6D61726B2C646F6E652C746F646F2C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D7371756172652D6F222C66696C746572733A22746F646F2C646F6E652C61';
wwv_flow_imp.g_varchar2_table(42) := '677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D6368696C64227D2C7B6E616D653A2266612D636972636C65222C66696C746572733A22646F742C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D63697263';
wwv_flow_imp.g_varchar2_table(43) := '6C652D302D38227D2C7B6E616D653A2266612D636972636C652D312D38227D2C7B6E616D653A2266612D636972636C652D322D38227D2C7B6E616D653A2266612D636972636C652D332D38227D2C7B6E616D653A2266612D636972636C652D342D38227D';
wwv_flow_imp.g_varchar2_table(44) := '2C7B6E616D653A2266612D636972636C652D352D38227D2C7B6E616D653A2266612D636972636C652D362D38227D2C7B6E616D653A2266612D636972636C652D372D38227D2C7B6E616D653A2266612D636972636C652D382D38227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(45) := '66612D636972636C652D6F227D2C7B6E616D653A2266612D636972636C652D6F2D6E6F746368227D2C7B6E616D653A2266612D636972636C652D7468696E227D2C7B6E616D653A2266612D636C6F636B2D6F222C66696C746572733A2277617463682C74';
wwv_flow_imp.g_varchar2_table(46) := '696D65722C6C6174652C74696D657374616D70227D2C7B6E616D653A2266612D636C6F6E65222C66696C746572733A22636F7079227D2C7B6E616D653A2266612D636C6F7564222C66696C746572733A2273617665227D2C7B6E616D653A2266612D636C';
wwv_flow_imp.g_varchar2_table(47) := '6F75642D6172726F772D646F776E227D2C7B6E616D653A2266612D636C6F75642D6172726F772D7570227D2C7B6E616D653A2266612D636C6F75642D62616E227D2C7B6E616D653A2266612D636C6F75642D626F6F6B6D61726B227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(48) := '66612D636C6F75642D6368617274227D2C7B6E616D653A2266612D636C6F75642D636865636B227D2C7B6E616D653A2266612D636C6F75642D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D636C6F75642D63';
wwv_flow_imp.g_varchar2_table(49) := '7572736F72227D2C7B6E616D653A2266612D636C6F75642D646F776E6C6F6164222C66696C746572733A22696D706F7274227D2C7B6E616D653A2266612D636C6F75642D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(50) := '612D636C6F75642D66696C65227D2C7B6E616D653A2266612D636C6F75642D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D636C6F75642D6C6F636B227D2C7B6E616D653A2266612D636C6F75';
wwv_flow_imp.g_varchar2_table(51) := '642D6E6577227D2C7B6E616D653A2266612D636C6F75642D706C6179227D2C7B6E616D653A2266612D636C6F75642D706C7573227D2C7B6E616D653A2266612D636C6F75642D706F696E746572227D2C7B6E616D653A2266612D636C6F75642D73656172';
wwv_flow_imp.g_varchar2_table(52) := '6368227D2C7B6E616D653A2266612D636C6F75642D75706C6F6164222C66696C746572733A22696D706F7274227D2C7B6E616D653A2266612D636C6F75642D75736572227D2C7B6E616D653A2266612D636C6F75642D7772656E6368227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(53) := '3A2266612D636C6F75642D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D636F6465222C66696C746572733A2268746D6C2C627261636B657473227D2C7B6E616D653A2266612D636F64652D666F726B22';
wwv_flow_imp.g_varchar2_table(54) := '2C66696C746572733A226769742C666F726B2C7663732C73766E2C6769746875622C7265626173652C76657273696F6E2C6D65726765227D2C7B6E616D653A2266612D636F64652D67726F7570222C66696C746572733A2267726F75702C6F7665726C61';
wwv_flow_imp.g_varchar2_table(55) := '70227D2C7B6E616D653A2266612D636F66666565222C66696C746572733A226D6F726E696E672C6D75672C627265616B666173742C7465612C6472696E6B2C63616665227D2C7B6E616D653A2266612D636F6C6C61707369626C65227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(56) := '2266612D636F6D6D656E74222C66696C746572733A227370656563682C6E6F74696669636174696F6E2C6E6F74652C636861742C627562626C652C666565646261636B227D2C7B6E616D653A2266612D636F6D6D656E742D6F222C66696C746572733A22';
wwv_flow_imp.g_varchar2_table(57) := '6E6F74696669636174696F6E2C6E6F7465227D2C7B6E616D653A2266612D636F6D6D656E74696E67227D2C7B6E616D653A2266612D636F6D6D656E74696E672D6F227D2C7B6E616D653A2266612D636F6D6D656E7473222C66696C746572733A22636F6E';
wwv_flow_imp.g_varchar2_table(58) := '766572736174696F6E2C6E6F74696669636174696F6E2C6E6F746573227D2C7B6E616D653A2266612D636F6D6D656E74732D6F222C66696C746572733A22636F6E766572736174696F6E2C6E6F74696669636174696F6E2C6E6F746573227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(59) := '653A2266612D636F6D70617373222C66696C746572733A227361666172692C6469726563746F72792C6D656E752C6C6F636174696F6E227D2C7B6E616D653A2266612D636F6E7461637473227D2C7B6E616D653A2266612D636F70797269676874227D2C';
wwv_flow_imp.g_varchar2_table(60) := '7B6E616D653A2266612D63726561746976652D636F6D6D6F6E73227D2C7B6E616D653A2266612D6372656469742D63617264222C66696C746572733A226D6F6E65792C6275792C64656269742C636865636B6F75742C70757263686173652C7061796D65';
wwv_flow_imp.g_varchar2_table(61) := '6E74227D2C7B6E616D653A2266612D6372656469742D636172642D616C74227D2C7B6E616D653A2266612D6372656469742D636172642D7465726D696E616C227D2C7B6E616D653A2266612D63726F70227D2C7B6E616D653A2266612D63726F73736861';
wwv_flow_imp.g_varchar2_table(62) := '697273222C66696C746572733A227069636B6572227D2C7B6E616D653A2266612D63756265227D2C7B6E616D653A2266612D6375626573227D2C7B6E616D653A2266612D6375746C657279222C66696C746572733A22666F6F642C72657374617572616E';
wwv_flow_imp.g_varchar2_table(63) := '742C73706F6F6E2C6B6E6966652C64696E6E65722C656174227D2C7B6E616D653A2266612D64617368626F617264222C66696C746572733A22746163686F6D65746572227D2C7B6E616D653A2266612D6461746162617365227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(64) := '2D64617461626173652D6172726F772D646F776E227D2C7B6E616D653A2266612D64617461626173652D6172726F772D7570227D2C7B6E616D653A2266612D64617461626173652D62616E227D2C7B6E616D653A2266612D64617461626173652D626F6F';
wwv_flow_imp.g_varchar2_table(65) := '6B6D61726B227D2C7B6E616D653A2266612D64617461626173652D6368617274227D2C7B6E616D653A2266612D64617461626173652D636865636B227D2C7B6E616D653A2266612D64617461626173652D636C6F636B222C66696C746572733A22686973';
wwv_flow_imp.g_varchar2_table(66) := '746F7279227D2C7B6E616D653A2266612D64617461626173652D637572736F72227D2C7B6E616D653A2266612D64617461626173652D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D64617461626173652D66696C';
wwv_flow_imp.g_varchar2_table(67) := '65227D2C7B6E616D653A2266612D64617461626173652D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D64617461626173652D6C6F636B227D2C7B6E616D653A2266612D64617461626173652D';
wwv_flow_imp.g_varchar2_table(68) := '6E6577227D2C7B6E616D653A2266612D64617461626173652D706C6179227D2C7B6E616D653A2266612D64617461626173652D706C7573227D2C7B6E616D653A2266612D64617461626173652D706F696E746572227D2C7B6E616D653A2266612D646174';
wwv_flow_imp.g_varchar2_table(69) := '61626173652D736561726368227D2C7B6E616D653A2266612D64617461626173652D75736572227D2C7B6E616D653A2266612D64617461626173652D7772656E6368227D2C7B6E616D653A2266612D64617461626173652D78222C66696C746572733A22';
wwv_flow_imp.g_varchar2_table(70) := '64656C6574652C72656D6F7665227D2C7B6E616D653A2266612D64656166227D2C7B6E616D653A2266612D646561666E657373227D2C7B6E616D653A2266612D64657369676E227D2C7B6E616D653A2266612D6465736B746F70222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(71) := '226D6F6E69746F722C73637265656E2C6465736B746F702C636F6D70757465722C64656D6F2C646576696365227D2C7B6E616D653A2266612D6469616D6F6E64222C66696C746572733A2267656D2C67656D73746F6E65227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(72) := '646F742D636972636C652D6F222C66696C746572733A227461726765742C62756C6C736579652C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D646F776E6C6F6164222C66696C746572733A22696D706F7274227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(73) := '612D646F776E6C6F61642D616C74227D2C7B6E616D653A2266612D64796E616D69632D636F6E74656E74227D2C7B6E616D653A2266612D65646974222C66696C746572733A2277726974652C656469742C757064617465227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(74) := '656C6C69707369732D68222C66696C746572733A22646F7473227D2C7B6E616D653A2266612D656C6C69707369732D682D6F227D2C7B6E616D653A2266612D656C6C69707369732D76222C66696C746572733A22646F7473227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(75) := '2D656C6C69707369732D762D6F227D2C7B6E616D653A2266612D656E76656C6F7065222C66696C746572733A22656D61696C2C656D61696C2C6C65747465722C737570706F72742C6D61696C2C6E6F74696669636174696F6E227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(76) := '612D656E76656C6F70652D6172726F772D646F776E227D2C7B6E616D653A2266612D656E76656C6F70652D6172726F772D7570227D2C7B6E616D653A2266612D656E76656C6F70652D62616E227D2C7B6E616D653A2266612D656E76656C6F70652D626F';
wwv_flow_imp.g_varchar2_table(77) := '6F6B6D61726B227D2C7B6E616D653A2266612D656E76656C6F70652D6368617274227D2C7B6E616D653A2266612D656E76656C6F70652D636865636B227D2C7B6E616D653A2266612D656E76656C6F70652D636C6F636B222C66696C746572733A226869';
wwv_flow_imp.g_varchar2_table(78) := '73746F7279227D2C7B6E616D653A2266612D656E76656C6F70652D637572736F72227D2C7B6E616D653A2266612D656E76656C6F70652D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D656E76656C6F70652D6865';
wwv_flow_imp.g_varchar2_table(79) := '617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D656E76656C6F70652D6C6F636B227D2C7B6E616D653A2266612D656E76656C6F70652D6F222C66696C746572733A22656D61696C2C737570706F7274';
wwv_flow_imp.g_varchar2_table(80) := '2C656D61696C2C6C65747465722C6D61696C2C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D656E76656C6F70652D6F70656E222C66696C746572733A226D61696C227D2C7B6E616D653A2266612D656E76656C6F70652D6F70656E2D6F';
wwv_flow_imp.g_varchar2_table(81) := '227D2C7B6E616D653A2266612D656E76656C6F70652D706C6179227D2C7B6E616D653A2266612D656E76656C6F70652D706C7573227D2C7B6E616D653A2266612D656E76656C6F70652D706F696E746572227D2C7B6E616D653A2266612D656E76656C6F';
wwv_flow_imp.g_varchar2_table(82) := '70652D736561726368227D2C7B6E616D653A2266612D656E76656C6F70652D737175617265227D2C7B6E616D653A2266612D656E76656C6F70652D75736572227D2C7B6E616D653A2266612D656E76656C6F70652D7772656E6368227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(83) := '2266612D656E76656C6F70652D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D657261736572227D2C7B6E616D653A2266612D657863657074696F6E222C66696C746572733A227761726E696E672C6572';
wwv_flow_imp.g_varchar2_table(84) := '726F72227D2C7B6E616D653A2266612D65786368616E6765222C66696C746572733A227472616E736665722C6172726F7773227D2C7B6E616D653A2266612D6578636C616D6174696F6E222C66696C746572733A227761726E696E672C6572726F722C70';
wwv_flow_imp.g_varchar2_table(85) := '726F626C656D2C6E6F74696669636174696F6E2C6E6F746966792C616C657274227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D636972636C65222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F7469';
wwv_flow_imp.g_varchar2_table(86) := '6669636174696F6E2C616C657274227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D636972636C652D6F222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C657274227D';
wwv_flow_imp.g_varchar2_table(87) := '2C7B6E616D653A2266612D6578636C616D6174696F6E2D6469616D6F6E64222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(88) := '612D6578636C616D6174696F6E2D6469616D6F6E642D6F222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C61';
wwv_flow_imp.g_varchar2_table(89) := '6D6174696F6E2D737175617265222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D737175';
wwv_flow_imp.g_varchar2_table(90) := '6172652D6F222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D747269616E676C65222C66';
wwv_flow_imp.g_varchar2_table(91) := '696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D747269616E676C652D6F222C66696C74657273';
wwv_flow_imp.g_varchar2_table(92) := '3A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D657870616E642D636F6C6C61707365222C66696C746572733A22706C75732C6D696E757322';
wwv_flow_imp.g_varchar2_table(93) := '7D2C7B6E616D653A2266612D65787465726E616C2D6C696E6B222C66696C746572733A226F70656E2C6E6577227D2C7B6E616D653A2266612D65787465726E616C2D6C696E6B2D737175617265222C66696C746572733A226F70656E2C6E6577227D2C7B';
wwv_flow_imp.g_varchar2_table(94) := '6E616D653A2266612D657965222C66696C746572733A2273686F772C76697369626C652C7669657773227D2C7B6E616D653A2266612D6579652D736C617368222C66696C746572733A22746F67676C652C73686F772C686964652C76697369626C652C76';
wwv_flow_imp.g_varchar2_table(95) := '697369626C6974792C7669657773227D2C7B6E616D653A2266612D65796564726F70706572227D2C7B6E616D653A2266612D666178227D2C7B6E616D653A2266612D66656564222C66696C746572733A22626C6F672C727373227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(96) := '612D66656D616C65222C66696C746572733A22776F6D616E2C757365722C706572736F6E2C70726F66696C65227D2C7B6E616D653A2266612D666967687465722D6A6574222C66696C746572733A22666C792C706C616E652C616972706C616E652C7175';
wwv_flow_imp.g_varchar2_table(97) := '69636B2C666173742C74726176656C227D2C7B6E616D653A2266612D666967687465722D6A65742D616C74222C66696C746572733A22706C616E65227D2C7B6E616D653A2266612D66696C652D617263686976652D6F222C66696C746572733A227A6970';
wwv_flow_imp.g_varchar2_table(98) := '227D2C7B6E616D653A2266612D66696C652D6172726F772D646F776E227D2C7B6E616D653A2266612D66696C652D6172726F772D7570227D2C7B6E616D653A2266612D66696C652D617564696F2D6F222C66696C746572733A22736F756E64227D2C7B6E';
wwv_flow_imp.g_varchar2_table(99) := '616D653A2266612D66696C652D62616E227D2C7B6E616D653A2266612D66696C652D626F6F6B6D61726B227D2C7B6E616D653A2266612D66696C652D6368617274227D2C7B6E616D653A2266612D66696C652D636865636B227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(100) := '2D66696C652D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D66696C652D636F64652D6F227D2C7B6E616D653A2266612D66696C652D637572736F72227D2C7B6E616D653A2266612D66696C652D6564697422';
wwv_flow_imp.g_varchar2_table(101) := '2C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D66696C652D657863656C2D6F227D2C7B6E616D653A2266612D66696C652D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(102) := '2D66696C652D696D6167652D6F222C66696C746572733A2270686F746F2C70696374757265227D2C7B6E616D653A2266612D66696C652D6C6F636B227D2C7B6E616D653A2266612D66696C652D6E6577227D2C7B6E616D653A2266612D66696C652D7064';
wwv_flow_imp.g_varchar2_table(103) := '662D6F227D2C7B6E616D653A2266612D66696C652D706C6179227D2C7B6E616D653A2266612D66696C652D706C7573227D2C7B6E616D653A2266612D66696C652D706F696E746572227D2C7B6E616D653A2266612D66696C652D706F776572706F696E74';
wwv_flow_imp.g_varchar2_table(104) := '2D6F227D2C7B6E616D653A2266612D66696C652D736561726368227D2C7B6E616D653A2266612D66696C652D73716C2D6F227D2C7B6E616D653A2266612D66696C652D75736572227D2C7B6E616D653A2266612D66696C652D766964656F2D6F222C6669';
wwv_flow_imp.g_varchar2_table(105) := '6C746572733A2266696C656D6F7669656F227D2C7B6E616D653A2266612D66696C652D776F72642D6F227D2C7B6E616D653A2266612D66696C652D7772656E6368227D2C7B6E616D653A2266612D66696C652D78222C66696C746572733A2264656C6574';
wwv_flow_imp.g_varchar2_table(106) := '652C72656D6F7665227D2C7B6E616D653A2266612D66696C6D222C66696C746572733A226D6F766965227D2C7B6E616D653A2266612D66696C746572222C66696C746572733A2266756E6E656C2C6F7074696F6E73227D2C7B6E616D653A2266612D6669';
wwv_flow_imp.g_varchar2_table(107) := '7265222C66696C746572733A22666C616D652C686F742C706F70756C6172227D2C7B6E616D653A2266612D666972652D657874696E67756973686572227D2C7B6E616D653A2266612D6669742D746F2D686569676874227D2C7B6E616D653A2266612D66';
wwv_flow_imp.g_varchar2_table(108) := '69742D746F2D73697A65227D2C7B6E616D653A2266612D6669742D746F2D7769647468227D2C7B6E616D653A2266612D666C6167222C66696C746572733A227265706F72742C6E6F74696669636174696F6E2C6E6F74696679227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(109) := '612D666C61672D636865636B65726564222C66696C746572733A227265706F72742C6E6F74696669636174696F6E2C6E6F74696679227D2C7B6E616D653A2266612D666C61672D6F222C66696C746572733A227265706F72742C6E6F7469666963617469';
wwv_flow_imp.g_varchar2_table(110) := '6F6E227D2C7B6E616D653A2266612D666C6173686C69676874222C66696C746572733A2266696E642C736561726368227D2C7B6E616D653A2266612D666C61736B222C66696C746572733A22736369656E63652C6265616B65722C6578706572696D656E';
wwv_flow_imp.g_varchar2_table(111) := '74616C2C6C616273227D2C7B6E616D653A2266612D666F6C646572227D2C7B6E616D653A2266612D666F6C6465722D6172726F772D646F776E227D2C7B6E616D653A2266612D666F6C6465722D6172726F772D7570227D2C7B6E616D653A2266612D666F';
wwv_flow_imp.g_varchar2_table(112) := '6C6465722D62616E227D2C7B6E616D653A2266612D666F6C6465722D626F6F6B6D61726B227D2C7B6E616D653A2266612D666F6C6465722D6368617274227D2C7B6E616D653A2266612D666F6C6465722D636865636B227D2C7B6E616D653A2266612D66';
wwv_flow_imp.g_varchar2_table(113) := '6F6C6465722D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D666F6C6465722D636C6F7564227D2C7B6E616D653A2266612D666F6C6465722D637572736F72227D2C7B6E616D653A2266612D666F6C6465722D';
wwv_flow_imp.g_varchar2_table(114) := '65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D666F6C6465722D66696C65227D2C7B6E616D653A2266612D666F6C6465722D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(115) := '6D653A2266612D666F6C6465722D6C6F636B227D2C7B6E616D653A2266612D666F6C6465722D6E6574776F726B227D2C7B6E616D653A2266612D666F6C6465722D6E6577227D2C7B6E616D653A2266612D666F6C6465722D6F227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(116) := '612D666F6C6465722D6F70656E227D2C7B6E616D653A2266612D666F6C6465722D6F70656E2D6F227D2C7B6E616D653A2266612D666F6C6465722D706C6179227D2C7B6E616D653A2266612D666F6C6465722D706C7573227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(117) := '666F6C6465722D706F696E746572227D2C7B6E616D653A2266612D666F6C6465722D736561726368227D2C7B6E616D653A2266612D666F6C6465722D75736572227D2C7B6E616D653A2266612D666F6C6465722D7772656E6368227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(118) := '66612D666F6C6465722D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D666F6C64657273227D2C7B6E616D653A2266612D666F6E742D73697A65222C66696C746572733A2274657874227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(119) := '3A2266612D666F6E742D73697A652D6465637265617365222C66696C746572733A2274657874227D2C7B6E616D653A2266612D666F6E742D73697A652D696E637265617365222C66696C746572733A2274657874227D2C7B6E616D653A2266612D666F72';
wwv_flow_imp.g_varchar2_table(120) := '6D6174222C66696C746572733A22696E64656E746174696F6E2C636F6465227D2C7B6E616D653A2266612D666F726D73222C66696C746572733A22696E707574227D2C7B6E616D653A2266612D66726F776E2D6F222C66696C746572733A22656D6F7469';
wwv_flow_imp.g_varchar2_table(121) := '636F6E2C7361642C646973617070726F76652C726174696E67227D2C7B6E616D653A2266612D66756E6374696F6E222C66696C746572733A22636F6D7075746174696F6E2C70726F6365647572652C6678227D2C7B6E616D653A2266612D667574626F6C';
wwv_flow_imp.g_varchar2_table(122) := '2D6F222C66696C746572733A22736F63636572227D2C7B6E616D653A2266612D67616D65706164222C66696C746572733A22636F6E74726F6C6C6572227D2C7B6E616D653A2266612D676176656C222C66696C746572733A226C6567616C227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(123) := '6D653A2266612D67656172222C66696C746572733A2273657474696E67732C636F67227D2C7B6E616D653A2266612D6765617273222C66696C746572733A22636F67732C73657474696E6773227D2C7B6E616D653A2266612D67696674222C66696C7465';
wwv_flow_imp.g_varchar2_table(124) := '72733A2270726573656E74227D2C7B6E616D653A2266612D676C617373222C66696C746572733A226D617274696E692C6472696E6B2C6261722C616C636F686F6C2C6C6971756F72227D2C7B6E616D653A2266612D676C6173736573227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(125) := '3A2266612D676C6F6265222C66696C746572733A22776F726C642C706C616E65742C6D61702C706C6163652C74726176656C2C65617274682C676C6F62616C2C7472616E736C6174652C616C6C2C6C616E67756167652C6C6F63616C697A652C6C6F6361';
wwv_flow_imp.g_varchar2_table(126) := '74696F6E2C636F6F7264696E617465732C636F756E747279227D2C7B6E616D653A2266612D67726164756174696F6E2D636170222C66696C746572733A226D6F7274617220626F6172642C6C6561726E696E672C7363686F6F6C2C73747564656E74227D';
wwv_flow_imp.g_varchar2_table(127) := '2C7B6E616D653A2266612D68616E642D677261622D6F222C66696C746572733A2268616E6420726F636B227D2C7B6E616D653A2266612D68616E642D6C697A6172642D6F227D2C7B6E616D653A2266612D68616E642D70656163652D6F227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(128) := '653A2266612D68616E642D706F696E7465722D6F227D2C7B6E616D653A2266612D68616E642D73636973736F72732D6F227D2C7B6E616D653A2266612D68616E642D73706F636B2D6F227D2C7B6E616D653A2266612D68616E642D73746F702D6F222C66';
wwv_flow_imp.g_varchar2_table(129) := '696C746572733A2268616E64207061706572227D2C7B6E616D653A2266612D68616E647368616B652D6F222C66696C746572733A2261677265656D656E74227D2C7B6E616D653A2266612D686172642D6F662D68656172696E67227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(130) := '66612D6861726477617265222C66696C746572733A22636869702C636F6D7075746572227D2C7B6E616D653A2266612D68617368746167227D2C7B6E616D653A2266612D6864642D6F222C66696C746572733A226861726464726976652C686172646472';
wwv_flow_imp.g_varchar2_table(131) := '6976652C73746F726167652C73617665227D2C7B6E616D653A2266612D6865616470686F6E6573222C66696C746572733A22736F756E642C6C697374656E2C6D75736963227D2C7B6E616D653A2266612D68656164736574222C66696C746572733A2263';
wwv_flow_imp.g_varchar2_table(132) := '6861742C737570706F72742C68656C70227D2C7B6E616D653A2266612D6865617274222C66696C746572733A226C6F76652C6C696B652C6661766F72697465227D2C7B6E616D653A2266612D68656172742D6F222C66696C746572733A226C6F76652C6C';
wwv_flow_imp.g_varchar2_table(133) := '696B652C6661766F72697465227D2C7B6E616D653A2266612D686561727462656174222C66696C746572733A22656B67227D2C7B6E616D653A2266612D68656C69636F70746572227D2C7B6E616D653A2266612D6865726F227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(134) := '2D686973746F7279227D2C7B6E616D653A2266612D686F6D65222C66696C746572733A226D61696E2C686F757365227D2C7B6E616D653A2266612D686F7572676C617373227D2C7B6E616D653A2266612D686F7572676C6173732D31222C66696C746572';
wwv_flow_imp.g_varchar2_table(135) := '733A22686F7572676C6173732D7374617274227D2C7B6E616D653A2266612D686F7572676C6173732D32222C66696C746572733A22686F7572676C6173732D68616C66227D2C7B6E616D653A2266612D686F7572676C6173732D33222C66696C74657273';
wwv_flow_imp.g_varchar2_table(136) := '3A22686F7572676C6173732D656E64227D2C7B6E616D653A2266612D686F7572676C6173732D6F227D2C7B6E616D653A2266612D692D637572736F72227D2C7B6E616D653A2266612D69642D6261646765222C66696C746572733A226C616E7961726422';
wwv_flow_imp.g_varchar2_table(137) := '7D2C7B6E616D653A2266612D69642D63617264222C66696C746572733A2264726976657273206C6963656E73652C206964656E74696669636174696F6E2C206964656E74697479227D2C7B6E616D653A2266612D69642D636172642D6F222C66696C7465';
wwv_flow_imp.g_varchar2_table(138) := '72733A2264726976657273206C6963656E73652C206964656E74696669636174696F6E2C206964656E74697479227D2C7B6E616D653A2266612D696D616765222C66696C746572733A2270686F746F2C70696374757265227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(139) := '696E626F78227D2C7B6E616D653A2266612D696E646578227D2C7B6E616D653A2266612D696E647573747279227D2C7B6E616D653A2266612D696E666F222C66696C746572733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C';
wwv_flow_imp.g_varchar2_table(140) := '73227D2C7B6E616D653A2266612D696E666F2D636972636C65222C66696C746572733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E616D653A2266612D696E666F2D636972636C652D6F222C66696C74657273';
wwv_flow_imp.g_varchar2_table(141) := '3A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E616D653A2266612D696E666F2D737175617265222C66696C746572733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E';
wwv_flow_imp.g_varchar2_table(142) := '616D653A2266612D696E666F2D7371756172652D6F222C66696C746572733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E616D653A2266612D6B6579222C66696C746572733A22756E6C6F636B2C7061737377';
wwv_flow_imp.g_varchar2_table(143) := '6F7264227D2C7B6E616D653A2266612D6B65792D616C74222C66696C746572733A226C6F636B2C6B6579227D2C7B6E616D653A2266612D6B6579626F6172642D6F222C66696C746572733A22747970652C696E707574227D2C7B6E616D653A2266612D6C';
wwv_flow_imp.g_varchar2_table(144) := '616E6775616765227D2C7B6E616D653A2266612D6C6170746F70222C66696C746572733A2264656D6F2C636F6D70757465722C646576696365227D2C7B6E616D653A2266612D6C6179657273227D2C7B6E616D653A2266612D6C61796F75742D31636F6C';
wwv_flow_imp.g_varchar2_table(145) := '2D32636F6C227D2C7B6E616D653A2266612D6C61796F75742D31636F6C2D33636F6C227D2C7B6E616D653A2266612D6C61796F75742D31726F772D32726F77227D2C7B6E616D653A2266612D6C61796F75742D32636F6C227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(146) := '6C61796F75742D32636F6C2D31636F6C227D2C7B6E616D653A2266612D6C61796F75742D32726F77227D2C7B6E616D653A2266612D6C61796F75742D32726F772D31726F77227D2C7B6E616D653A2266612D6C61796F75742D33636F6C227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(147) := '653A2266612D6C61796F75742D33636F6C2D31636F6C227D2C7B6E616D653A2266612D6C61796F75742D33726F77227D2C7B6E616D653A2266612D6C61796F75742D626C616E6B227D2C7B6E616D653A2266612D6C61796F75742D666F6F746572227D2C';
wwv_flow_imp.g_varchar2_table(148) := '7B6E616D653A2266612D6C61796F75742D677269642D3378227D2C7B6E616D653A2266612D6C61796F75742D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D31636F6C2D33636F6C227D2C7B6E616D653A2266612D6C';
wwv_flow_imp.g_varchar2_table(149) := '61796F75742D6865616465722D32726F77227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D666F6F746572227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D6E61762D6C6566742D6361726473227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(150) := '2266612D6C61796F75742D6865616465722D6E61762D6C6566742D72696768742D666F6F746572227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D6E61762D72696768742D6361726473227D2C7B6E616D653A2266612D6C61796F7574';
wwv_flow_imp.g_varchar2_table(151) := '2D6865616465722D736964656261722D6C656674227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D736964656261722D7269676874227D2C7B6E616D653A2266612D6C61796F75742D6C6973742D6C656674227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(152) := '612D6C61796F75742D6C6973742D7269676874227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D626C616E6B227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D636F6C756D6E73227D2C7B6E616D653A2266612D6C61796F';
wwv_flow_imp.g_varchar2_table(153) := '75742D6D6F64616C2D677269642D3278227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D6E61762D6C656674227D2C7B6E616D653A2266612D6C61796F75';
wwv_flow_imp.g_varchar2_table(154) := '742D6D6F64616C2D6E61762D7269676874227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D726F7773227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C656674227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C';
wwv_flow_imp.g_varchar2_table(155) := '6566742D6361726473227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D68616D627572676572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D68616D6275726765722D686561646572227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(156) := '3A2266612D6C61796F75742D6E61762D6C6566742D6865616465722D6361726473227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D6865616465722D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C';
wwv_flow_imp.g_varchar2_table(157) := '6566742D7269676874227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D72696768742D6865616465722D666F6F746572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D7269676874227D2C7B6E616D653A2266612D6C';
wwv_flow_imp.g_varchar2_table(158) := '61796F75742D6E61762D72696768742D6361726473227D2C7B6E616D653A2266612D6C61796F75742D6E61762D72696768742D68616D627572676572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D72696768742D68616D6275726765722D';
wwv_flow_imp.g_varchar2_table(159) := '686561646572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D72696768742D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D72696768742D6865616465722D6361726473227D2C7B6E616D653A2266612D6C6179';
wwv_flow_imp.g_varchar2_table(160) := '6F75742D736964656261722D6C656674227D2C7B6E616D653A2266612D6C61796F75742D736964656261722D7269676874227D2C7B6E616D653A2266612D6C61796F7574732D677269642D3278227D2C7B6E616D653A2266612D6C656166222C66696C74';
wwv_flow_imp.g_varchar2_table(161) := '6572733A2265636F2C6E6174757265227D2C7B6E616D653A2266612D6C656D6F6E2D6F227D2C7B6E616D653A2266612D6C6576656C2D646F776E227D2C7B6E616D653A2266612D6C6576656C2D7570227D2C7B6E616D653A2266612D6C6966652D72696E';
wwv_flow_imp.g_varchar2_table(162) := '67222C66696C746572733A226C69666562756F792C6C69666573617665722C737570706F7274227D2C7B6E616D653A2266612D6C6967687462756C622D6F222C66696C746572733A22696465612C696E737069726174696F6E227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(163) := '612D6C696E652D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D6C6F636174696F6E2D6172726F772D6F222C66696C746572733A226D61702C636F6F7264696E617465732C6C6F63617469';
wwv_flow_imp.g_varchar2_table(164) := '6F6E2C616464726573732C706C6163652C7768657265227D2C7B6E616D653A2266612D6C6F636B222C66696C746572733A2270726F746563742C61646D696E227D2C7B6E616D653A2266612D6C6F636B2D636865636B227D2C7B6E616D653A2266612D6C';
wwv_flow_imp.g_varchar2_table(165) := '6F636B2D66696C65227D2C7B6E616D653A2266612D6C6F636B2D6E6577227D2C7B6E616D653A2266612D6C6F636B2D70617373776F7264227D2C7B6E616D653A2266612D6C6F636B2D706C7573227D2C7B6E616D653A2266612D6C6F636B2D7573657222';
wwv_flow_imp.g_varchar2_table(166) := '7D2C7B6E616D653A2266612D6C6F636B2D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D6C6F772D766973696F6E227D2C7B6E616D653A2266612D6D61676963222C66696C746572733A2277697A617264';
wwv_flow_imp.g_varchar2_table(167) := '2C6175746F6D617469632C6175746F636F6D706C657465227D2C7B6E616D653A2266612D6D61676E6574227D2C7B6E616D653A2266612D6D61696C2D666F7277617264222C66696C746572733A226D61696C207368617265227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(168) := '2D6D616C65222C66696C746572733A226D616E2C757365722C706572736F6E2C70726F66696C65227D2C7B6E616D653A2266612D6D6170227D2C7B6E616D653A2266612D6D61702D6D61726B65722D6F222C66696C746572733A226D61702C70696E2C6C';
wwv_flow_imp.g_varchar2_table(169) := '6F636174696F6E2C636F6F7264696E617465732C6C6F63616C697A652C616464726573732C74726176656C2C77686572652C706C616365227D2C7B6E616D653A2266612D6D61702D6F227D2C7B6E616D653A2266612D6D61702D70696E227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(170) := '653A2266612D6D61702D7369676E73227D2C7B6E616D653A2266612D6D6174657269616C697A65642D76696577227D2C7B6E616D653A2266612D6D656469612D6C697374227D2C7B6E616D653A2266612D6D65682D6F222C66696C746572733A22656D6F';
wwv_flow_imp.g_varchar2_table(171) := '7469636F6E2C726174696E672C6E65757472616C227D2C7B6E616D653A2266612D6D6963726F63686970222C66696C746572733A2273696C69636F6E2C636869702C637075227D2C7B6E616D653A2266612D6D6963726F70686F6E65222C66696C746572';
wwv_flow_imp.g_varchar2_table(172) := '733A227265636F72642C766F6963652C736F756E64227D2C7B6E616D653A2266612D6D6963726F70686F6E652D736C617368222C66696C746572733A227265636F72642C766F6963652C736F756E642C6D757465227D2C7B6E616D653A2266612D6D696C';
wwv_flow_imp.g_varchar2_table(173) := '69746172792D76656869636C65222C66696C746572733A2268756D7665652C6361722C747275636B227D2C7B6E616D653A2266612D6D696E7573222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C7472617368';
wwv_flow_imp.g_varchar2_table(174) := '2C686964652C636F6C6C61707365227D2C7B6E616D653A2266612D6D696E75732D636972636C65222C66696C746572733A2264656C6574652C72656D6F76652C74726173682C68696465227D2C7B6E616D653A2266612D6D696E75732D636972636C652D';
wwv_flow_imp.g_varchar2_table(175) := '6F222C66696C746572733A2264656C6574652C72656D6F76652C74726173682C68696465227D2C7B6E616D653A2266612D6D696E75732D737175617265222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C7472';
wwv_flow_imp.g_varchar2_table(176) := '6173682C686964652C636F6C6C61707365227D2C7B6E616D653A2266612D6D696E75732D7371756172652D6F222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964652C636F6C6C61707365';
wwv_flow_imp.g_varchar2_table(177) := '227D2C7B6E616D653A2266612D6D697373696C65227D2C7B6E616D653A2266612D6D6F62696C65222C66696C746572733A2263656C6C70686F6E652C63656C6C70686F6E652C746578742C63616C6C2C6970686F6E652C6E756D6265722C70686F6E6522';
wwv_flow_imp.g_varchar2_table(178) := '7D2C7B6E616D653A2266612D6D6F6E6579222C66696C746572733A22636173682C6D6F6E65792C6275792C636865636B6F75742C70757263686173652C7061796D656E74227D2C7B6E616D653A2266612D6D6F6F6E2D6F222C66696C746572733A226E69';
wwv_flow_imp.g_varchar2_table(179) := '6768742C6461726B65722C636F6E7472617374227D2C7B6E616D653A2266612D6D6F746F726379636C65222C66696C746572733A2276656869636C652C62696B65227D2C7B6E616D653A2266612D6D6F7573652D706F696E746572227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(180) := '2266612D6D75736963222C66696C746572733A226E6F74652C736F756E64227D2C7B6E616D653A2266612D6E617669636F6E222C66696C746572733A2272656F726465722C6D656E752C647261672C72656F726465722C73657474696E67732C6C697374';
wwv_flow_imp.g_varchar2_table(181) := '2C756C2C6F6C2C636865636B6C6973742C746F646F2C6C6973742C68616D627572676572227D2C7B6E616D653A2266612D6E6574776F726B2D687562227D2C7B6E616D653A2266612D6E6574776F726B2D747269616E676C65227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(182) := '612D6E65777370617065722D6F222C66696C746572733A227072657373227D2C7B6E616D653A2266612D6E6F7465626F6F6B227D2C7B6E616D653A2266612D6F626A6563742D67726F7570227D2C7B6E616D653A2266612D6F626A6563742D756E67726F';
wwv_flow_imp.g_varchar2_table(183) := '7570227D2C7B6E616D653A2266612D6F66666963652D70686F6E65222C66696C746572733A2270686F6E652C666178227D2C7B6E616D653A2266612D7061636B616765222C66696C746572733A2270726F64756374227D2C7B6E616D653A2266612D7061';
wwv_flow_imp.g_varchar2_table(184) := '646C6F636B227D2C7B6E616D653A2266612D7061646C6F636B2D756E6C6F636B227D2C7B6E616D653A2266612D7061696E742D6272757368227D2C7B6E616D653A2266612D70617065722D706C616E65222C66696C746572733A2273656E64227D2C7B6E';
wwv_flow_imp.g_varchar2_table(185) := '616D653A2266612D70617065722D706C616E652D6F222C66696C746572733A2273656E646F227D2C7B6E616D653A2266612D706177222C66696C746572733A22706574227D2C7B6E616D653A2266612D70656E63696C222C66696C746572733A22777269';
wwv_flow_imp.g_varchar2_table(186) := '74652C656469742C757064617465227D2C7B6E616D653A2266612D70656E63696C2D737175617265222C66696C746572733A2277726974652C656469742C757064617465227D2C7B6E616D653A2266612D70656E63696C2D7371756172652D6F222C6669';
wwv_flow_imp.g_varchar2_table(187) := '6C746572733A2277726974652C656469742C7570646174652C65646974227D2C7B6E616D653A2266612D70657263656E74227D2C7B6E616D653A2266612D70686F6E65222C66696C746572733A2263616C6C2C766F6963652C6E756D6265722C73757070';
wwv_flow_imp.g_varchar2_table(188) := '6F72742C65617270686F6E65227D2C7B6E616D653A2266612D70686F6E652D737175617265222C66696C746572733A2263616C6C2C766F6963652C6E756D6265722C737570706F7274227D2C7B6E616D653A2266612D70686F746F222C66696C74657273';
wwv_flow_imp.g_varchar2_table(189) := '3A22696D6167652C70696374757265227D2C7B6E616D653A2266612D7069652D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D706C616E65222C66696C746572733A2274726176656C2C74';
wwv_flow_imp.g_varchar2_table(190) := '7269702C6C6F636174696F6E2C64657374696E6174696F6E2C616972706C616E652C666C792C6D6F6465227D2C7B6E616D653A2266612D706C7567227D2C7B6E616D653A2266612D706C7573222C66696C746572733A226164642C6E65772C6372656174';
wwv_flow_imp.g_varchar2_table(191) := '652C657870616E64227D2C7B6E616D653A2266612D706C75732D636972636C65222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706C75732D636972636C652D6F222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(192) := '226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706C75732D737175617265222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706C75732D73717561';
wwv_flow_imp.g_varchar2_table(193) := '72652D6F222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706F6463617374227D2C7B6E616D653A2266612D706F7765722D6F6666222C66696C746572733A226F6E227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(194) := '2266612D707261676D61222C66696C746572733A226E756D6265722C7369676E2C686173682C7368617270227D2C7B6E616D653A2266612D7072696E74227D2C7B6E616D653A2266612D70726F636564757265222C66696C746572733A22636F6D707574';
wwv_flow_imp.g_varchar2_table(195) := '6174696F6E2C66756E6374696F6E227D2C7B6E616D653A2266612D70757A7A6C652D7069656365222C66696C746572733A226164646F6E2C6164646F6E2C73656374696F6E227D2C7B6E616D653A2266612D7172636F6465222C66696C746572733A2273';
wwv_flow_imp.g_varchar2_table(196) := '63616E227D2C7B6E616D653A2266612D7175657374696F6E222C66696C746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D7175657374696F6E2D636972636C65222C66696C';
wwv_flow_imp.g_varchar2_table(197) := '746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D7175657374696F6E2D636972636C652D6F222C66696C746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E';
wwv_flow_imp.g_varchar2_table(198) := '6F776E2C737570706F7274227D2C7B6E616D653A2266612D7175657374696F6E2D737175617265222C66696C746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D7175657374';
wwv_flow_imp.g_varchar2_table(199) := '696F6E2D7371756172652D6F222C66696C746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D71756F74652D6C656674227D2C7B6E616D653A2266612D71756F74652D726967';
wwv_flow_imp.g_varchar2_table(200) := '6874227D2C7B6E616D653A2266612D72616E646F6D222C66696C746572733A22736F72742C73687566666C65227D2C7B6E616D653A2266612D72656379636C65227D2C7B6E616D653A2266612D7265646F2D616C74227D2C7B6E616D653A2266612D7265';
wwv_flow_imp.g_varchar2_table(201) := '646F2D6172726F77227D2C7B6E616D653A2266612D72656672657368222C66696C746572733A2272656C6F61642C73796E63227D2C7B6E616D653A2266612D72656769737465726564227D2C7B6E616D653A2266612D72656D6F7665222C66696C746572';
wwv_flow_imp.g_varchar2_table(202) := '733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D7265706C79222C66696C746572733A226D61696C227D2C7B6E616D653A2266612D7265706C792D616C6C222C66696C746572733A22';
wwv_flow_imp.g_varchar2_table(203) := '6D61696C227D2C7B6E616D653A2266612D72657477656574222C66696C746572733A22726566726573682C72656C6F61642C7368617265227D2C7B6E616D653A2266612D726F6164222C66696C746572733A22737472656574227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(204) := '612D726F636B6574222C66696C746572733A22617070227D2C7B6E616D653A2266612D727373222C66696C746572733A22626C6F672C66656564227D2C7B6E616D653A2266612D7273732D737175617265222C66696C746572733A22666565642C626C6F';
wwv_flow_imp.g_varchar2_table(205) := '67227D2C7B6E616D653A2266612D736176652D6173227D2C7B6E616D653A2266612D736561726368222C66696C746572733A226D61676E6966792C7A6F6F6D2C656E6C617267652C626967676572227D2C7B6E616D653A2266612D7365617263682D6D69';
wwv_flow_imp.g_varchar2_table(206) := '6E7573222C66696C746572733A226D61676E6966792C6D696E6966792C7A6F6F6D2C736D616C6C6572227D2C7B6E616D653A2266612D7365617263682D706C7573222C66696C746572733A226D61676E6966792C7A6F6F6D2C656E6C617267652C626967';
wwv_flow_imp.g_varchar2_table(207) := '676572227D2C7B6E616D653A2266612D73656E64222C66696C746572733A22706C616E65227D2C7B6E616D653A2266612D73656E642D6F222C66696C746572733A22706C616E65227D2C7B6E616D653A2266612D73657175656E6365227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(208) := '3A2266612D736572766572227D2C7B6E616D653A2266612D7365727665722D6172726F772D646F776E227D2C7B6E616D653A2266612D7365727665722D6172726F772D7570227D2C7B6E616D653A2266612D7365727665722D62616E227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(209) := '3A2266612D7365727665722D626F6F6B6D61726B227D2C7B6E616D653A2266612D7365727665722D6368617274227D2C7B6E616D653A2266612D7365727665722D636865636B227D2C7B6E616D653A2266612D7365727665722D636C6F636B222C66696C';
wwv_flow_imp.g_varchar2_table(210) := '746572733A22686973746F7279227D2C7B6E616D653A2266612D7365727665722D65646974227D2C7B6E616D653A2266612D7365727665722D66696C65227D2C7B6E616D653A2266612D7365727665722D6865617274227D2C7B6E616D653A2266612D73';
wwv_flow_imp.g_varchar2_table(211) := '65727665722D6C6F636B227D2C7B6E616D653A2266612D7365727665722D6E6577227D2C7B6E616D653A2266612D7365727665722D706C6179227D2C7B6E616D653A2266612D7365727665722D706C7573227D2C7B6E616D653A2266612D736572766572';
wwv_flow_imp.g_varchar2_table(212) := '2D706F696E746572227D2C7B6E616D653A2266612D7365727665722D736561726368227D2C7B6E616D653A2266612D7365727665722D75736572227D2C7B6E616D653A2266612D7365727665722D7772656E6368227D2C7B6E616D653A2266612D736572';
wwv_flow_imp.g_varchar2_table(213) := '7665722D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D736861706573222C66696C746572733A227368617265642C636F6D706F6E656E7473227D2C7B6E616D653A2266612D7368617265222C66696C74';
wwv_flow_imp.g_varchar2_table(214) := '6572733A226D61696C20666F7277617264227D2C7B6E616D653A2266612D73686172652D616C74227D2C7B6E616D653A2266612D73686172652D616C742D737175617265227D2C7B6E616D653A2266612D73686172652D737175617265222C66696C7465';
wwv_flow_imp.g_varchar2_table(215) := '72733A22736F6369616C2C73656E64227D2C7B6E616D653A2266612D73686172652D7371756172652D6F222C66696C746572733A22736F6369616C2C73656E64227D2C7B6E616D653A2266612D736861726532227D2C7B6E616D653A2266612D73686965';
wwv_flow_imp.g_varchar2_table(216) := '6C64222C66696C746572733A2261776172642C616368696576656D656E742C77696E6E6572227D2C7B6E616D653A2266612D73686970222C66696C746572733A22626F61742C736561227D2C7B6E616D653A2266612D73686F7070696E672D626167227D';
wwv_flow_imp.g_varchar2_table(217) := '2C7B6E616D653A2266612D73686F7070696E672D6261736B6574227D2C7B6E616D653A2266612D73686F7070696E672D63617274222C66696C746572733A22636865636B6F75742C6275792C70757263686173652C7061796D656E74227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(218) := '3A2266612D73686F776572227D2C7B6E616D653A2266612D7369676E2D696E222C66696C746572733A22656E7465722C6A6F696E2C6C6F67696E2C6C6F67696E2C7369676E75702C7369676E696E2C7369676E696E2C7369676E75702C6172726F77227D';
wwv_flow_imp.g_varchar2_table(219) := '2C7B6E616D653A2266612D7369676E2D6C616E6775616765227D2C7B6E616D653A2266612D7369676E2D6F7574222C66696C746572733A226C6F676F75742C6C6F676F75742C6C656176652C657869742C6172726F77227D2C7B6E616D653A2266612D73';
wwv_flow_imp.g_varchar2_table(220) := '69676E616C227D2C7B6E616D653A2266612D7369676E696E67227D2C7B6E616D653A2266612D736974656D6170222C66696C746572733A226469726563746F72792C6869657261726368792C6F7267616E697A6174696F6E227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(221) := '2D736974656D61702D686F72697A6F6E74616C227D2C7B6E616D653A2266612D736974656D61702D766572746963616C227D2C7B6E616D653A2266612D736C6964657273227D2C7B6E616D653A2266612D736D696C652D6F222C66696C746572733A2265';
wwv_flow_imp.g_varchar2_table(222) := '6D6F7469636F6E2C68617070792C617070726F76652C7361746973666965642C726174696E67227D2C7B6E616D653A2266612D736E6F77666C616B65222C66696C746572733A2266726F7A656E227D2C7B6E616D653A2266612D736F636365722D62616C';
wwv_flow_imp.g_varchar2_table(223) := '6C2D6F222C66696C746572733A22666F6F7462616C6C227D2C7B6E616D653A2266612D736F7274222C66696C746572733A226F726465722C756E736F72746564227D2C7B6E616D653A2266612D736F72742D616C7068612D617363227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(224) := '2266612D736F72742D616C7068612D64657363227D2C7B6E616D653A2266612D736F72742D616D6F756E742D617363227D2C7B6E616D653A2266612D736F72742D616D6F756E742D64657363227D2C7B6E616D653A2266612D736F72742D617363222C66';
wwv_flow_imp.g_varchar2_table(225) := '696C746572733A227570227D2C7B6E616D653A2266612D736F72742D64657363222C66696C746572733A2264726F70646F776E2C6D6F72652C6D656E752C646F776E227D2C7B6E616D653A2266612D736F72742D6E756D657269632D617363222C66696C';
wwv_flow_imp.g_varchar2_table(226) := '746572733A226E756D62657273227D2C7B6E616D653A2266612D736F72742D6E756D657269632D64657363222C66696C746572733A226E756D62657273227D2C7B6E616D653A2266612D73706163652D73687574746C65227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(227) := '7370696E6E6572222C66696C746572733A226C6F6164696E672C70726F6772657373227D2C7B6E616D653A2266612D73706F6F6E227D2C7B6E616D653A2266612D737175617265222C66696C746572733A22626C6F636B2C626F78227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(228) := '2266612D7371756172652D6F222C66696C746572733A22626C6F636B2C7371756172652C626F78227D2C7B6E616D653A2266612D7371756172652D73656C65637465642D6F222C66696C746572733A22626C6F636B2C7371756172652C626F78227D2C7B';
wwv_flow_imp.g_varchar2_table(229) := '6E616D653A2266612D73746172222C66696C746572733A2261776172642C616368696576656D656E742C6E696768742C726174696E672C73636F7265227D2C7B6E616D653A2266612D737461722D68616C66222C66696C746572733A2261776172642C61';
wwv_flow_imp.g_varchar2_table(230) := '6368696576656D656E742C726174696E672C73636F7265227D2C7B6E616D653A2266612D737461722D68616C662D6F222C66696C746572733A2261776172642C616368696576656D656E742C726174696E672C73636F72652C68616C66227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(231) := '653A2266612D737461722D6F222C66696C746572733A2261776172642C616368696576656D656E742C6E696768742C726174696E672C73636F7265227D2C7B6E616D653A2266612D737469636B792D6E6F7465227D2C7B6E616D653A2266612D73746963';
wwv_flow_imp.g_varchar2_table(232) := '6B792D6E6F74652D6F227D2C7B6E616D653A2266612D7374726565742D76696577222C66696C746572733A226D6170227D2C7B6E616D653A2266612D7375697463617365222C66696C746572733A22747269702C6C7567676167652C74726176656C2C6D';
wwv_flow_imp.g_varchar2_table(233) := '6F76652C62616767616765227D2C7B6E616D653A2266612D73756E2D6F222C66696C746572733A22776561746865722C636F6E74726173742C6C6967687465722C627269676874656E2C646179227D2C7B6E616D653A2266612D737570706F7274222C66';
wwv_flow_imp.g_varchar2_table(234) := '696C746572733A226C69666562756F792C6C69666573617665722C6C69666572696E67227D2C7B6E616D653A2266612D73796E6F6E796D222C66696C746572733A22636F70792C6475706C6963617465227D2C7B6E616D653A2266612D7461626C652D61';
wwv_flow_imp.g_varchar2_table(235) := '72726F772D646F776E227D2C7B6E616D653A2266612D7461626C652D6172726F772D7570227D2C7B6E616D653A2266612D7461626C652D62616E227D2C7B6E616D653A2266612D7461626C652D626F6F6B6D61726B227D2C7B6E616D653A2266612D7461';
wwv_flow_imp.g_varchar2_table(236) := '626C652D6368617274227D2C7B6E616D653A2266612D7461626C652D636865636B227D2C7B6E616D653A2266612D7461626C652D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D7461626C652D637572736F72';
wwv_flow_imp.g_varchar2_table(237) := '227D2C7B6E616D653A2266612D7461626C652D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D7461626C652D66696C65227D2C7B6E616D653A2266612D7461626C652D6865617274222C66696C746572733A226C69';
wwv_flow_imp.g_varchar2_table(238) := '6B652C6661766F72697465227D2C7B6E616D653A2266612D7461626C652D6C6F636B227D2C7B6E616D653A2266612D7461626C652D6E6577227D2C7B6E616D653A2266612D7461626C652D706C6179227D2C7B6E616D653A2266612D7461626C652D706C';
wwv_flow_imp.g_varchar2_table(239) := '7573227D2C7B6E616D653A2266612D7461626C652D706F696E746572227D2C7B6E616D653A2266612D7461626C652D736561726368227D2C7B6E616D653A2266612D7461626C652D75736572227D2C7B6E616D653A2266612D7461626C652D7772656E63';
wwv_flow_imp.g_varchar2_table(240) := '68227D2C7B6E616D653A2266612D7461626C652D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D7461626C6574222C66696C746572733A22697061642C646576696365227D2C7B6E616D653A2266612D74';
wwv_flow_imp.g_varchar2_table(241) := '616273227D2C7B6E616D653A2266612D746163686F6D65746572222C66696C746572733A2264617368626F617264227D2C7B6E616D653A2266612D746167222C66696C746572733A226C6162656C227D2C7B6E616D653A2266612D74616773222C66696C';
wwv_flow_imp.g_varchar2_table(242) := '746572733A226C6162656C73227D2C7B6E616D653A2266612D74616E6B227D2C7B6E616D653A2266612D7461736B73222C66696C746572733A2270726F67726573732C6C6F6164696E672C646F776E6C6F6164696E672C646F776E6C6F6164732C736574';
wwv_flow_imp.g_varchar2_table(243) := '74696E6773227D2C7B6E616D653A2266612D74617869222C66696C746572733A226361622C76656869636C65227D2C7B6E616D653A2266612D74656C65766973696F6E222C66696C746572733A227476227D2C7B6E616D653A2266612D7465726D696E61';
wwv_flow_imp.g_varchar2_table(244) := '6C222C66696C746572733A22636F6D6D616E642C70726F6D70742C636F6465227D2C7B6E616D653A2266612D746865726D6F6D657465722D30222C66696C746572733A22746865726D6F6D657465722D656D707479227D2C7B6E616D653A2266612D7468';
wwv_flow_imp.g_varchar2_table(245) := '65726D6F6D657465722D31222C66696C746572733A22746865726D6F6D657465722D71756172746572227D2C7B6E616D653A2266612D746865726D6F6D657465722D32222C66696C746572733A22746865726D6F6D657465722D68616C66227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(246) := '6D653A2266612D746865726D6F6D657465722D33222C66696C746572733A22746865726D6F6D657465722D74687265652D7175617274657273227D2C7B6E616D653A2266612D746865726D6F6D657465722D34222C66696C746572733A22746865726D6F';
wwv_flow_imp.g_varchar2_table(247) := '6D657465722D66756C6C2C746865726D6F6D65746572227D2C7B6E616D653A2266612D7468756D622D7461636B222C66696C746572733A226D61726B65722C70696E2C6C6F636174696F6E2C636F6F7264696E61746573227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(248) := '7468756D62732D646F776E222C66696C746572733A226469736C696B652C646973617070726F76652C64697361677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D6F2D646F776E222C66696C746572733A226469736C696B652C64';
wwv_flow_imp.g_varchar2_table(249) := '6973617070726F76652C64697361677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D6F2D7570222C66696C746572733A226C696B652C617070726F76652C6661766F726974652C61677265652C68616E64227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(250) := '66612D7468756D62732D7570222C66696C746572733A226C696B652C6661766F726974652C617070726F76652C61677265652C68616E64227D2C7B6E616D653A2266612D7469636B6574222C66696C746572733A226D6F7669652C706173732C73757070';
wwv_flow_imp.g_varchar2_table(251) := '6F7274227D2C7B6E616D653A2266612D74696C65732D327832227D2C7B6E616D653A2266612D74696C65732D337833227D2C7B6E616D653A2266612D74696C65732D38227D2C7B6E616D653A2266612D74696C65732D39227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(252) := '74696D6573222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D74696D65732D636972636C65222C66696C746572733A22636C6F73652C657869742C78227D2C7B6E';
wwv_flow_imp.g_varchar2_table(253) := '616D653A2266612D74696D65732D636972636C652D6F222C66696C746572733A22636C6F73652C657869742C78227D2C7B6E616D653A2266612D74696D65732D72656374616E676C65222C66696C746572733A2272656D6F76652C636C6F73652C636C6F';
wwv_flow_imp.g_varchar2_table(254) := '73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D74696D65732D72656374616E676C652D6F222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(255) := '74696E74222C66696C746572733A227261696E64726F702C776174657264726F702C64726F702C64726F706C6574227D2C7B6E616D653A2266612D746F67676C652D6F6666227D2C7B6E616D653A2266612D746F67676C652D6F6E227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(256) := '2266612D746F6F6C73222C66696C746572733A2273637265776472697665722C7772656E6368227D2C7B6E616D653A2266612D74726164656D61726B227D2C7B6E616D653A2266612D7472617368222C66696C746572733A22676172626167652C64656C';
wwv_flow_imp.g_varchar2_table(257) := '6574652C72656D6F76652C68696465227D2C7B6E616D653A2266612D74726173682D6F222C66696C746572733A22676172626167652C64656C6574652C72656D6F76652C74726173682C68696465227D2C7B6E616D653A2266612D74726565227D2C7B6E';
wwv_flow_imp.g_varchar2_table(258) := '616D653A2266612D747265652D6F7267227D2C7B6E616D653A2266612D74726967676572227D2C7B6E616D653A2266612D74726F706879222C66696C746572733A2261776172642C616368696576656D656E742C77696E6E65722C67616D65227D2C7B6E';
wwv_flow_imp.g_varchar2_table(259) := '616D653A2266612D747275636B222C66696C746572733A227368697070696E67227D2C7B6E616D653A2266612D747479227D2C7B6E616D653A2266612D756D6272656C6C61227D2C7B6E616D653A2266612D756E646F2D616C74227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(260) := '66612D756E646F2D6172726F77227D2C7B6E616D653A2266612D756E6976657273616C2D616363657373227D2C7B6E616D653A2266612D756E6976657273697479222C66696C746572733A22696E737469747574696F6E2C62616E6B227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(261) := '3A2266612D756E6C6F636B222C66696C746572733A2270726F746563742C61646D696E2C70617373776F72642C6C6F636B227D2C7B6E616D653A2266612D756E6C6F636B2D616C74222C66696C746572733A2270726F746563742C61646D696E2C706173';
wwv_flow_imp.g_varchar2_table(262) := '73776F72642C6C6F636B227D2C7B6E616D653A2266612D75706C6F6164222C66696C746572733A22696D706F7274227D2C7B6E616D653A2266612D75706C6F61642D616C74227D2C7B6E616D653A2266612D75736572222C66696C746572733A22706572';
wwv_flow_imp.g_varchar2_table(263) := '736F6E2C6D616E2C686561642C70726F66696C65227D2C7B6E616D653A2266612D757365722D6172726F772D646F776E227D2C7B6E616D653A2266612D757365722D6172726F772D7570227D2C7B6E616D653A2266612D757365722D62616E227D2C7B6E';
wwv_flow_imp.g_varchar2_table(264) := '616D653A2266612D757365722D6368617274227D2C7B6E616D653A2266612D757365722D636865636B227D2C7B6E616D653A2266612D757365722D636972636C65227D2C7B6E616D653A2266612D757365722D636972636C652D6F227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(265) := '2266612D757365722D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D757365722D637572736F72227D2C7B6E616D653A2266612D757365722D65646974222C66696C746572733A2270656E63696C227D2C7B6E';
wwv_flow_imp.g_varchar2_table(266) := '616D653A2266612D757365722D6772616475617465227D2C7B6E616D653A2266612D757365722D68656164736574227D2C7B6E616D653A2266612D757365722D6865617274222C66696C746572733A226C696B652C6661766F726974652C6C6F7665227D';
wwv_flow_imp.g_varchar2_table(267) := '2C7B6E616D653A2266612D757365722D6C6F636B227D2C7B6E616D653A2266612D757365722D6D61676E696679696E672D676C617373227D2C7B6E616D653A2266612D757365722D6D616E227D2C7B6E616D653A2266612D757365722D706C6179227D2C';
wwv_flow_imp.g_varchar2_table(268) := '7B6E616D653A2266612D757365722D706C7573222C66696C746572733A227369676E75702C7369676E7570227D2C7B6E616D653A2266612D757365722D706F696E746572227D2C7B6E616D653A2266612D757365722D736563726574222C66696C746572';
wwv_flow_imp.g_varchar2_table(269) := '733A22776869737065722C7370792C696E636F676E69746F227D2C7B6E616D653A2266612D757365722D776F6D616E227D2C7B6E616D653A2266612D757365722D7772656E6368227D2C7B6E616D653A2266612D757365722D78227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(270) := '66612D7573657273222C66696C746572733A2270656F706C652C70726F66696C65732C706572736F6E732C67726F7570227D2C7B6E616D653A2266612D75736572732D63686174227D2C7B6E616D653A2266612D7661726961626C65227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(271) := '3A2266612D766964656F2D63616D657261222C66696C746572733A2266696C6D2C6D6F7669652C7265636F7264227D2C7B6E616D653A2266612D766F6C756D652D636F6E74726F6C2D70686F6E65227D2C7B6E616D653A2266612D766F6C756D652D646F';
wwv_flow_imp.g_varchar2_table(272) := '776E222C66696C746572733A226C6F7765722C717569657465722C736F756E642C6D75736963227D2C7B6E616D653A2266612D766F6C756D652D6F6666222C66696C746572733A226D7574652C736F756E642C6D75736963227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(273) := '2D766F6C756D652D7570222C66696C746572733A226869676865722C6C6F756465722C736F756E642C6D75736963227D2C7B6E616D653A2266612D7761726E696E67222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E';
wwv_flow_imp.g_varchar2_table(274) := '6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D776865656C6368616972222C66696C746572733A2268616E64696361702C706572736F6E2C6163636573736962696C6974792C61636365737369626C6522';
wwv_flow_imp.g_varchar2_table(275) := '7D2C7B6E616D653A2266612D776865656C63686169722D616C74227D2C7B6E616D653A2266612D77696669227D2C7B6E616D653A2266612D77696E646F77227D2C7B6E616D653A2266612D77696E646F772D616C74227D2C7B6E616D653A2266612D7769';
wwv_flow_imp.g_varchar2_table(276) := '6E646F772D616C742D32227D2C7B6E616D653A2266612D77696E646F772D6172726F772D646F776E227D2C7B6E616D653A2266612D77696E646F772D6172726F772D7570227D2C7B6E616D653A2266612D77696E646F772D62616E227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(277) := '2266612D77696E646F772D626F6F6B6D61726B227D2C7B6E616D653A2266612D77696E646F772D6368617274227D2C7B6E616D653A2266612D77696E646F772D636865636B227D2C7B6E616D653A2266612D77696E646F772D636C6F636B222C66696C74';
wwv_flow_imp.g_varchar2_table(278) := '6572733A22686973746F7279227D2C7B6E616D653A2266612D77696E646F772D636C6F7365222C66696C746572733A2274696D65732C2072656374616E676C65227D2C7B6E616D653A2266612D77696E646F772D636C6F73652D6F222C66696C74657273';
wwv_flow_imp.g_varchar2_table(279) := '3A2274696D65732C2072656374616E676C65227D2C7B6E616D653A2266612D77696E646F772D637572736F72227D2C7B6E616D653A2266612D77696E646F772D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D7769';
wwv_flow_imp.g_varchar2_table(280) := '6E646F772D66696C65227D2C7B6E616D653A2266612D77696E646F772D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D77696E646F772D6C6F636B227D2C7B6E616D653A2266612D77696E646F';
wwv_flow_imp.g_varchar2_table(281) := '772D6D6178696D697A65227D2C7B6E616D653A2266612D77696E646F772D6D696E696D697A65227D2C7B6E616D653A2266612D77696E646F772D6E6577227D2C7B6E616D653A2266612D77696E646F772D706C6179227D2C7B6E616D653A2266612D7769';
wwv_flow_imp.g_varchar2_table(282) := '6E646F772D706C7573227D2C7B6E616D653A2266612D77696E646F772D706F696E746572227D2C7B6E616D653A2266612D77696E646F772D726573746F7265227D2C7B6E616D653A2266612D77696E646F772D736561726368227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(283) := '612D77696E646F772D7465726D696E616C222C66696C746572733A22636F6E736F6C65227D2C7B6E616D653A2266612D77696E646F772D75736572227D2C7B6E616D653A2266612D77696E646F772D7772656E6368227D2C7B6E616D653A2266612D7769';
wwv_flow_imp.g_varchar2_table(284) := '6E646F772D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D77697A617264222C66696C746572733A2273746570732C70726F6772657373227D2C7B6E616D653A2266612D7772656E6368222C66696C7465';
wwv_flow_imp.g_varchar2_table(285) := '72733A2273657474696E67732C6669782C757064617465227D2C7B6E616D653A2266612D746578742D636F6C6F72222C66696C746572733A22746578742C656469746F722C666F6E742C666F726D61742C636F6C6F72227D2C7B6E616D653A2266612D61';
wwv_flow_imp.g_varchar2_table(286) := '6261637573222C66696C746572733A226D6174682C6D617468656D61746963732C636F756E74696E672C63616C63756C61746F72227D2C7B6E616D653A2266612D66726F776E222C66696C746572733A22656D6F74696F6E2C666163652C656D6F6A692C';
wwv_flow_imp.g_varchar2_table(287) := '736164227D2C7B6E616D653A2266612D6D6568222C66696C746572733A22656D6F74696F6E2C666163652C656D6F6A692C6E65757472616C227D2C7B6E616D653A2266612D736D696C65222C66696C746572733A22656D6F74696F6E2C666163652C656D';
wwv_flow_imp.g_varchar2_table(288) := '6F6A692C6861707079227D2C7B6E616D653A2266612D73697A652D78786C222C66696C746572733A226D6561737572656D656E742C73686972742C6261646765227D2C7B6E616D653A2266612D73697A652D786C222C66696C746572733A226D65617375';
wwv_flow_imp.g_varchar2_table(289) := '72656D656E742C73686972742C6261646765227D2C7B6E616D653A2266612D73697A652D6C222C66696C746572733A226D6561737572656D656E742C73686972742C6261646765227D2C7B6E616D653A2266612D73697A652D6D222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(290) := '226D6561737572656D656E742C73686972742C6261646765227D2C7B6E616D653A2266612D73697A652D73222C66696C746572733A226D6561737572656D656E742C73686972742C6261646765227D2C7B6E616D653A2266612D73697A652D7873222C66';
wwv_flow_imp.g_varchar2_table(291) := '696C746572733A226D6561737572656D656E742C73686972742C6261646765227D2C7B6E616D653A2266612D686561742D6D6170222C66696C746572733A22627562626C652C73706F742C636972636C65227D2C7B6E616D653A2266612D666C61672D73';
wwv_flow_imp.g_varchar2_table(292) := '77616C6C6F777461696C2D6F222C66696C746572733A226D61702C6D61726B65722C70696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E67227D2C7B6E616D653A2266612D666C61672D7377616C6C6F777461696C222C';
wwv_flow_imp.g_varchar2_table(293) := '66696C746572733A226D61702C6D61726B65722C70696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E67227D2C7B6E616D653A2266612D666C61672D70656E6E616E742D6F222C66696C746572733A226D61702C6D6172';
wwv_flow_imp.g_varchar2_table(294) := '6B65722C70696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E67227D2C7B6E616D653A2266612D666C61672D70656E6E616E74222C66696C746572733A226D61702C6D61726B65722C70696E2C6E617669676174696F6E';
wwv_flow_imp.g_varchar2_table(295) := '2C6C6F636174696F6E2C7761792066696E64696E67227D2C7B6E616D653A2266612D616C61726D2D636C6F636B222C66696C746572733A2274696D65227D2C7B6E616D653A2266612D616C61726D2D636865636B222C66696C746572733A2274696D6522';
wwv_flow_imp.g_varchar2_table(296) := '7D2C7B6E616D653A2266612D616C61726D2D736E6F6F7A65222C66696C746572733A2274696D65227D2C7B6E616D653A2266612D616C61726D2D706C7573222C66696C746572733A2274696D65227D2C7B6E616D653A2266612D616C61726D2D6D696E75';
wwv_flow_imp.g_varchar2_table(297) := '73222C66696C746572733A2274696D65227D2C7B6E616D653A2266612D616C61726D2D74696D6573222C66696C746572733A2274696D65227D2C7B6E616D653A2266612D757365722D736C617368222C66696C746572733A22706572736F6E227D2C7B6E';
wwv_flow_imp.g_varchar2_table(298) := '616D653A2266612D75736572732D616C74222C66696C746572733A22706572736F6E227D2C7B6E616D653A2266612D706F6469756D222C66696C746572733A2270726573656E746174696F6E2C70726573656E7465722C6C6563747572652C6C65637475';
wwv_flow_imp.g_varchar2_table(299) := '7265722C737065616B6572227D2C7B6E616D653A2266612D70726573656E746174696F6E222C66696C746572733A2263686172742C70726573656E746174696F6E2C706572666F726D616E6365227D2C7B6E616D653A2266612D616E616C797469637322';
wwv_flow_imp.g_varchar2_table(300) := '2C66696C746572733A22616E616C797A652C6D61676E696679696E6720676C6173732C7365617263682C6172726F772C7570227D2C7B6E616D653A2266612D7461736B732D616C74222C66696C746572733A22636865636B2C6C6973742C737572766579';
wwv_flow_imp.g_varchar2_table(301) := '227D2C7B6E616D653A2266612D6275672D736C617368222C66696C746572733A22696E73656374227D2C7B6E616D653A2266612D66696C652D627261636B657473222C66696C746572733A2270726F6772616D6D696E672C636F6465227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(302) := '3A2266612D66696C652D6373762D6F222C66696C746572733A2270726F6772616D6D696E672C636F6465227D2C7B6E616D653A2266612D66696C652D6A736F6E2D6F222C66696C746572733A2270726F6772616D6D696E672C636F6465227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(303) := '653A2266612D66696C652D7369676E6174757265222C66696C746572733A227369676E2C617574686F72697A65642C636F6E7472616374227D2C7B6E616D653A2266612D736F72742D616D6F756E742D6173632D616C74227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(304) := '736F72742D616D6F756E742D646573632D616C74227D2C7B6E616D653A2266612D343034222C66696C746572733A2262726F6B656E206C696E6B2C6572726F722070616765227D2C7B6E616D653A2266612D346B227D2C7B6E616D653A2266612D616363';
wwv_flow_imp.g_varchar2_table(305) := '6F7264696F6E222C66696C746572733A226E617669676174696F6E2C6D656E752C6C6973742C657870616E64227D2C7B6E616D653A2266612D6163636573736F722D6D6F7265222C66696C746572733A2270726F6772616D6D696E672C6E6574776F726B';
wwv_flow_imp.g_varchar2_table(306) := '2C6272616E63682C636F6E6E656374696F6E227D2C7B6E616D653A2266612D6163636573736F722D6F6E65222C66696C746572733A2270726F6772616D6D696E672C6E6574776F726B2C636F6E6E656374696F6E227D2C7B6E616D653A2266612D626164';
wwv_flow_imp.g_varchar2_table(307) := '6765222C66696C746572733A22737461747573227D2C7B6E616D653A2266612D62616467652D636865636B222C66696C746572733A22737461747573227D2C7B6E616D653A2266612D62616467652D646F6C6C6172222C66696C746572733A2273746174';
wwv_flow_imp.g_varchar2_table(308) := '7573227D2C7B6E616D653A2266612D62616467652D70657263656E74222C66696C746572733A22737461747573227D2C7B6E616D653A2266612D776F726B666C6F77222C66696C746572733A226465636973696F6E2C6272616E63682C6D6F64656C2C64';
wwv_flow_imp.g_varchar2_table(309) := '69616772616D227D5D2C544558545F454449544F523A5B7B6E616D653A2266612D616C69676E2D63656E746572222C66696C746572733A226D6964646C652C74657874227D2C7B6E616D653A2266612D616C69676E2D6A757374696679222C66696C7465';
wwv_flow_imp.g_varchar2_table(310) := '72733A2274657874227D2C7B6E616D653A2266612D616C69676E2D6C656674222C66696C746572733A2274657874227D2C7B6E616D653A2266612D616C69676E2D7269676874222C66696C746572733A2274657874227D2C7B6E616D653A2266612D626F';
wwv_flow_imp.g_varchar2_table(311) := '6C64227D2C7B6E616D653A2266612D636C6970626F617264222C66696C746572733A22636F70792C7061737465227D2C7B6E616D653A2266612D636C6970626F6172642D6172726F772D646F776E227D2C7B6E616D653A2266612D636C6970626F617264';
wwv_flow_imp.g_varchar2_table(312) := '2D6172726F772D7570227D2C7B6E616D653A2266612D636C6970626F6172642D62616E227D2C7B6E616D653A2266612D636C6970626F6172642D626F6F6B6D61726B227D2C7B6E616D653A2266612D636C6970626F6172642D636861727420227D2C7B6E';
wwv_flow_imp.g_varchar2_table(313) := '616D653A2266612D636C6970626F6172642D636865636B227D2C7B6E616D653A2266612D636C6970626F6172642D636865636B2D616C74227D2C7B6E616D653A2266612D636C6970626F6172642D636C6F636B227D2C7B6E616D653A2266612D636C6970';
wwv_flow_imp.g_varchar2_table(314) := '626F6172642D65646974227D2C7B6E616D653A2266612D636C6970626F6172642D6865617274227D2C7B6E616D653A2266612D636C6970626F6172642D6C697374227D2C7B6E616D653A2266612D636C6970626F6172642D6C6F636B227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(315) := '3A2266612D636C6970626F6172642D6E6577227D2C7B6E616D653A2266612D636C6970626F6172642D706C7573227D2C7B6E616D653A2266612D636C6970626F6172642D706F696E746572227D2C7B6E616D653A2266612D636C6970626F6172642D7365';
wwv_flow_imp.g_varchar2_table(316) := '61726368227D2C7B6E616D653A2266612D636C6970626F6172642D75736572227D2C7B6E616D653A2266612D636C6970626F6172642D7772656E6368227D2C7B6E616D653A2266612D636C6970626F6172642D78227D2C7B6E616D653A2266612D636F6C';
wwv_flow_imp.g_varchar2_table(317) := '756D6E73222C66696C746572733A2273706C69742C70616E6573227D2C7B6E616D653A2266612D636F7079222C66696C746572733A226475706C69636174652C636F7079227D2C7B6E616D653A2266612D637574222C66696C746572733A227363697373';
wwv_flow_imp.g_varchar2_table(318) := '6F7273227D2C7B6E616D653A2266612D657261736572227D2C7B6E616D653A2266612D66696C65222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D6F222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(319) := '226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D74657874222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D746578742D6F';
wwv_flow_imp.g_varchar2_table(320) := '222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C65732D6F222C66696C746572733A226475706C69636174652C636F7079227D2C7B6E616D653A2266612D666F6E74222C66696C74';
wwv_flow_imp.g_varchar2_table(321) := '6572733A2274657874227D2C7B6E616D653A2266612D686561646572222C66696C746572733A2268656164696E67227D2C7B6E616D653A2266612D696E64656E74227D2C7B6E616D653A2266612D6974616C6963222C66696C746572733A226974616C69';
wwv_flow_imp.g_varchar2_table(322) := '6373227D2C7B6E616D653A2266612D6C696E6B222C66696C746572733A22636861696E227D2C7B6E616D653A2266612D6C697374222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C66696E69736865642C636F6D706C657465642C646F';
wwv_flow_imp.g_varchar2_table(323) := '6E652C746F646F227D2C7B6E616D653A2266612D6C6973742D616C74222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C66696E69736865642C636F6D706C657465642C646F6E652C746F646F227D2C7B6E616D653A2266612D6C697374';
wwv_flow_imp.g_varchar2_table(324) := '2D6F6C222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C6C6973742C746F646F2C6C6973742C6E756D62657273227D2C7B6E616D653A2266612D6C6973742D756C222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C74';
wwv_flow_imp.g_varchar2_table(325) := '6F646F2C6C697374227D2C7B6E616D653A2266612D6F757464656E74222C66696C746572733A22646564656E74227D2C7B6E616D653A2266612D7061706572636C6970222C66696C746572733A226174746163686D656E74227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(326) := '2D706172616772617068227D2C7B6E616D653A2266612D7061737465222C66696C746572733A22636C6970626F617264227D2C7B6E616D653A2266612D726570656174222C66696C746572733A227265646F2C666F72776172642C726F74617465227D2C';
wwv_flow_imp.g_varchar2_table(327) := '7B6E616D653A2266612D726F746174652D6C656674222C66696C746572733A226261636B2C756E646F227D2C7B6E616D653A2266612D726F746174652D7269676874222C66696C746572733A227265646F2C666F72776172642C726570656174227D2C7B';
wwv_flow_imp.g_varchar2_table(328) := '6E616D653A2266612D73617665222C66696C746572733A22666C6F707079227D2C7B6E616D653A2266612D73636973736F7273222C66696C746572733A22637574227D2C7B6E616D653A2266612D737472696B657468726F756768227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(329) := '2266612D737562736372697074227D2C7B6E616D653A2266612D7375706572736372697074222C66696C746572733A226578706F6E656E7469616C227D2C7B6E616D653A2266612D7461626C65222C66696C746572733A22646174612C657863656C2C73';
wwv_flow_imp.g_varchar2_table(330) := '70726561647368656574227D2C7B6E616D653A2266612D746578742D686569676874227D2C7B6E616D653A2266612D746578742D7769647468227D2C7B6E616D653A2266612D7468222C66696C746572733A22626C6F636B732C737175617265732C626F';
wwv_flow_imp.g_varchar2_table(331) := '7865732C67726964227D2C7B6E616D653A2266612D74682D6C61726765222C66696C746572733A22626C6F636B732C737175617265732C626F7865732C67726964227D2C7B6E616D653A2266612D74682D6C697374222C66696C746572733A22756C2C6F';
wwv_flow_imp.g_varchar2_table(332) := '6C2C636865636B6C6973742C66696E69736865642C636F6D706C657465642C646F6E652C746F646F227D2C7B6E616D653A2266612D756E6465726C696E65227D2C7B6E616D653A2266612D756E646F222C66696C746572733A226261636B2C726F746174';
wwv_flow_imp.g_varchar2_table(333) := '65227D2C7B6E616D653A2266612D756E6C696E6B222C66696C746572733A2272656D6F76652C636861696E2C62726F6B656E227D5D2C4D45444943414C3A5B7B6E616D653A2266612D616D62756C616E6365222C66696C746572733A22737570706F7274';
wwv_flow_imp.g_varchar2_table(334) := '2C68656C70227D2C7B6E616D653A2266612D682D737175617265222C66696C746572733A22686F73706974616C2C686F74656C227D2C7B6E616D653A2266612D6865617274222C66696C746572733A226C6F76652C6C696B652C6661766F72697465227D';
wwv_flow_imp.g_varchar2_table(335) := '2C7B6E616D653A2266612D68656172742D6F222C66696C746572733A226C6F76652C6C696B652C6661766F72697465227D2C7B6E616D653A2266612D686561727462656174222C66696C746572733A22656B67227D2C7B6E616D653A2266612D686F7370';
wwv_flow_imp.g_varchar2_table(336) := '6974616C2D6F222C66696C746572733A226275696C64696E67227D2C7B6E616D653A2266612D6D65646B6974222C66696C746572733A2266697273746169642C66697273746169642C68656C702C737570706F72742C6865616C7468227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(337) := '3A2266612D706C75732D737175617265222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D73746574686F73636F7065227D2C7B6E616D653A2266612D757365722D6D64222C66696C746572';
wwv_flow_imp.g_varchar2_table(338) := '733A22646F63746F722C70726F66696C652C6D65646963616C2C6E75727365227D2C7B6E616D653A2266612D776865656C6368616972222C66696C746572733A2268616E64696361702C706572736F6E2C6163636573736962696C6974792C6163636573';
wwv_flow_imp.g_varchar2_table(339) := '7369626C65227D2C7B6E616D653A2266612D6E75727365222C66696C746572733A22686F73706974616C2C646F63746F722C706172616D65646963227D2C7B6E616D653A2266612D62696F68617A617264222C66696C746572733A2264616E6765722C77';
wwv_flow_imp.g_varchar2_table(340) := '61737465227D2C7B6E616D653A2266612D707265736372697074696F6E2D7368656574222C66696C746572733A226D65646963696E652C64727567227D2C7B6E616D653A2266612D726164696174696F6E222C66696C746572733A2264616E6765722C78';
wwv_flow_imp.g_varchar2_table(341) := '207261792C6E75636C656172227D2C7B6E616D653A2266612D737972696E6765222C66696C746572733A226D65646963696E652C647275672C73686F742C76616363696E652C6E6565646C65227D2C7B6E616D653A2266612D7669616C222C66696C7465';
wwv_flow_imp.g_varchar2_table(342) := '72733A226D65646963696E652C647275672C666F726D756C612C736369656E63652C7465737420747562652C6368656D6973747279227D2C7B6E616D653A2266612D7669616C73222C66696C746572733A226D65646963696E652C647275672C666F726D';
wwv_flow_imp.g_varchar2_table(343) := '756C612C736369656E63652C7465737420747562652C6368656D6973747279227D2C7B6E616D653A2266612D782D726179222C66696C746572733A226578616D2C686F73706974616C227D2C7B6E616D653A2266612D66696C652D6D65646963616C227D';
wwv_flow_imp.g_varchar2_table(344) := '2C7B6E616D653A2266612D66696C652D707265736372697074696F6E222C66696C746572733A22647275672C6D65646963696E65227D2C7B6E616D653A2266612D6D656469636174696F6E2D70696C6C73222C66696C746572733A226D65646963696E65';
wwv_flow_imp.g_varchar2_table(345) := '2C64727567227D2C7B6E616D653A2266612D6D656469636174696F6E2D70696C6C2D626F74746C65222C66696C746572733A226D65646963696E652C64727567227D2C7B6E616D653A2266612D6D656469636174696F6E2D70696C6C222C66696C746572';
wwv_flow_imp.g_varchar2_table(346) := '733A226D65646963696E652C64727567227D2C7B6E616D653A2266612D6D656469636174696F6E222C66696C746572733A226D65646963696E652C64727567227D2C7B6E616D653A2266612D6D65646963616C2D6D61736B222C66696C746572733A2273';
wwv_flow_imp.g_varchar2_table(347) := '61666574792C70726F74656374696F6E227D2C7B6E616D653A2266612D707265736372697074696F6E222C66696C746572733A226D65646963696E652C64727567227D5D2C5452414E53504F52544154494F4E3A5B7B6E616D653A2266612D616D62756C';
wwv_flow_imp.g_varchar2_table(348) := '616E6365222C66696C746572733A22737570706F72742C68656C70227D2C7B6E616D653A2266612D62696379636C65222C66696C746572733A2276656869636C652C62696B65227D2C7B6E616D653A2266612D627573222C66696C746572733A22766568';
wwv_flow_imp.g_varchar2_table(349) := '69636C65227D2C7B6E616D653A2266612D636172222C66696C746572733A226175746F6D6F62696C652C76656869636C65227D2C7B6E616D653A2266612D666967687465722D6A6574222C66696C746572733A22666C792C706C616E652C616972706C61';
wwv_flow_imp.g_varchar2_table(350) := '6E652C717569636B2C666173742C74726176656C227D2C7B6E616D653A2266612D6D6F746F726379636C65222C66696C746572733A2276656869636C652C62696B65227D2C7B6E616D653A2266612D706C616E65222C66696C746572733A227472617665';
wwv_flow_imp.g_varchar2_table(351) := '6C2C747269702C6C6F636174696F6E2C64657374696E6174696F6E2C616972706C616E652C666C792C6D6F6465227D2C7B6E616D653A2266612D726F636B6574222C66696C746572733A22617070227D2C7B6E616D653A2266612D73686970222C66696C';
wwv_flow_imp.g_varchar2_table(352) := '746572733A22626F61742C736561227D2C7B6E616D653A2266612D73706163652D73687574746C65227D2C7B6E616D653A2266612D737562776179227D2C7B6E616D653A2266612D74617869222C66696C746572733A226361622C76656869636C65227D';
wwv_flow_imp.g_varchar2_table(353) := '2C7B6E616D653A2266612D747261696E227D2C7B6E616D653A2266612D747275636B222C66696C746572733A227368697070696E67227D2C7B6E616D653A2266612D776865656C6368616972222C66696C746572733A2268616E64696361702C70657273';
wwv_flow_imp.g_varchar2_table(354) := '6F6E2C6163636573736962696C6974792C61636365737369626C65227D5D2C4143434553534942494C4954593A5B7B6E616D653A2266612D616D65726963616E2D7369676E2D6C616E67756167652D696E74657270726574696E67227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(355) := '2266612D61736C2D696E74657270726574696E67227D2C7B6E616D653A2266612D6173736973746976652D6C697374656E696E672D73797374656D73227D2C7B6E616D653A2266612D617564696F2D6465736372697074696F6E227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(356) := '66612D626C696E64227D2C7B6E616D653A2266612D627261696C6C65227D2C7B6E616D653A2266612D64656166227D2C7B6E616D653A2266612D646561666E657373227D2C7B6E616D653A2266612D686172642D6F662D68656172696E67227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(357) := '6D653A2266612D6C6F772D766973696F6E227D2C7B6E616D653A2266612D7369676E2D6C616E6775616765227D2C7B6E616D653A2266612D7369676E696E67227D2C7B6E616D653A2266612D756E6976657273616C2D616363657373227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(358) := '3A2266612D766F6C756D652D636F6E74726F6C2D70686F6E65227D2C7B6E616D653A2266612D776865656C63686169722D616C74227D5D2C444952454354494F4E414C3A5B7B6E616D653A2266612D616E676C652D646F75626C652D646F776E227D2C7B';
wwv_flow_imp.g_varchar2_table(359) := '6E616D653A2266612D616E676C652D646F75626C652D6C656674222C66696C746572733A226C6171756F2C71756F74652C70726576696F75732C6261636B227D2C7B6E616D653A2266612D616E676C652D646F75626C652D7269676874222C66696C7465';
wwv_flow_imp.g_varchar2_table(360) := '72733A22726171756F2C71756F74652C6E6578742C666F7277617264227D2C7B6E616D653A2266612D616E676C652D646F75626C652D7570227D2C7B6E616D653A2266612D616E676C652D646F776E227D2C7B6E616D653A2266612D616E676C652D6C65';
wwv_flow_imp.g_varchar2_table(361) := '6674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D616E676C652D7269676874222C66696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D616E676C652D7570227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(362) := '6D653A2266612D6172726F772D636972636C652D646F776E222C66696C746572733A22646F776E6C6F6164227D2C7B6E616D653A2266612D6172726F772D636972636C652D6C656674222C66696C746572733A2270726576696F75732C6261636B227D2C';
wwv_flow_imp.g_varchar2_table(363) := '7B6E616D653A2266612D6172726F772D636972636C652D6F2D646F776E222C66696C746572733A22646F776E6C6F6164227D2C7B6E616D653A2266612D6172726F772D636972636C652D6F2D6C656674222C66696C746572733A2270726576696F75732C';
wwv_flow_imp.g_varchar2_table(364) := '6261636B227D2C7B6E616D653A2266612D6172726F772D636972636C652D6F2D7269676874222C66696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D6172726F772D636972636C652D6F2D7570227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(365) := '66612D6172726F772D636972636C652D7269676874222C66696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D6172726F772D636972636C652D7570227D2C7B6E616D653A2266612D6172726F772D646F776E222C66696C';
wwv_flow_imp.g_varchar2_table(366) := '746572733A22646F776E6C6F6164227D2C7B6E616D653A2266612D6172726F772D646F776E2D616C74227D2C7B6E616D653A2266612D6172726F772D646F776E2D6C6566742D616C74227D2C7B6E616D653A2266612D6172726F772D646F776E2D726967';
wwv_flow_imp.g_varchar2_table(367) := '68742D616C74227D2C7B6E616D653A2266612D6172726F772D6C656674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D6172726F772D6C6566742D616C74227D2C7B6E616D653A2266612D6172726F772D72';
wwv_flow_imp.g_varchar2_table(368) := '69676874222C66696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D6172726F772D72696768742D616C74227D2C7B6E616D653A2266612D6172726F772D7570227D2C7B6E616D653A2266612D6172726F772D75702D616C';
wwv_flow_imp.g_varchar2_table(369) := '74227D2C7B6E616D653A2266612D6172726F772D75702D6C6566742D616C74227D2C7B6E616D653A2266612D6172726F772D75702D72696768742D616C74227D2C7B6E616D653A2266612D6172726F7773222C66696C746572733A226D6F76652C72656F';
wwv_flow_imp.g_varchar2_table(370) := '726465722C726573697A65227D2C7B6E616D653A2266612D6172726F77732D616C74222C66696C746572733A22657870616E642C656E6C617267652C66756C6C73637265656E2C6269676765722C6D6F76652C72656F726465722C726573697A65227D2C';
wwv_flow_imp.g_varchar2_table(371) := '7B6E616D653A2266612D6172726F77732D68222C66696C746572733A22726573697A65227D2C7B6E616D653A2266612D6172726F77732D76222C66696C746572733A22726573697A65227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D65';
wwv_flow_imp.g_varchar2_table(372) := '617374227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D6E65227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D6E6F727468227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D6E77227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(373) := '66612D626F782D6172726F772D696E2D7365227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D736F757468227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D7377227D2C7B6E616D653A2266612D626F782D6172726F772D';
wwv_flow_imp.g_varchar2_table(374) := '696E2D77657374227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D65617374227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D6E65227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D6E6F72746822';
wwv_flow_imp.g_varchar2_table(375) := '7D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D6E77227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D7365227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D736F757468227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(376) := '612D626F782D6172726F772D6F75742D7377227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D77657374227D2C7B6E616D653A2266612D63617265742D646F776E222C66696C746572733A226D6F72652C64726F70646F776E2C6D656E';
wwv_flow_imp.g_varchar2_table(377) := '752C747269616E676C65646F776E227D2C7B6E616D653A2266612D63617265742D6C656674222C66696C746572733A2270726576696F75732C6261636B2C747269616E676C656C656674227D2C7B6E616D653A2266612D63617265742D7269676874222C';
wwv_flow_imp.g_varchar2_table(378) := '66696C746572733A226E6578742C666F72776172642C747269616E676C657269676874227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D646F776E222C66696C746572733A22746F67676C65646F776E2C6D6F72652C64726F70646F';
wwv_flow_imp.g_varchar2_table(379) := '776E2C6D656E75227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D6C656674222C66696C746572733A2270726576696F75732C6261636B2C746F67676C656C656674227D2C7B6E616D653A2266612D63617265742D7371756172652D';
wwv_flow_imp.g_varchar2_table(380) := '6F2D7269676874222C66696C746572733A226E6578742C666F72776172642C746F67676C657269676874227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D7570222C66696C746572733A22746F67676C657570227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(381) := '2266612D63617265742D7570222C66696C746572733A22747269616E676C657570227D2C7B6E616D653A2266612D63686576726F6E2D636972636C652D646F776E222C66696C746572733A226D6F72652C64726F70646F776E2C6D656E75227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(382) := '6D653A2266612D63686576726F6E2D636972636C652D6C656674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D63686576726F6E2D636972636C652D7269676874222C66696C746572733A226E6578742C66';
wwv_flow_imp.g_varchar2_table(383) := '6F7277617264227D2C7B6E616D653A2266612D63686576726F6E2D636972636C652D7570227D2C7B6E616D653A2266612D63686576726F6E2D646F776E227D2C7B6E616D653A2266612D63686576726F6E2D6C656674222C66696C746572733A22627261';
wwv_flow_imp.g_varchar2_table(384) := '636B65742C70726576696F75732C6261636B227D2C7B6E616D653A2266612D63686576726F6E2D7269676874222C66696C746572733A22627261636B65742C6E6578742C666F7277617264227D2C7B6E616D653A2266612D63686576726F6E2D7570227D';
wwv_flow_imp.g_varchar2_table(385) := '2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D65617374227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D6E65227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D6E6F727468227D2C7B';
wwv_flow_imp.g_varchar2_table(386) := '6E616D653A2266612D636972636C652D6172726F772D696E2D6E77227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D7365227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D736F757468227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(387) := '3A2266612D636972636C652D6172726F772D696E2D7377227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D77657374227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D65617374227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(388) := '66612D636972636C652D6172726F772D6F75742D6E65227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D6E6F727468227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D6E77227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(389) := '612D636972636C652D6172726F772D6F75742D7365227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D736F757468227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D7377227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(390) := '2D636972636C652D6172726F772D6F75742D77657374227D2C7B6E616D653A2266612D65786368616E6765222C66696C746572733A227472616E736665722C6172726F7773227D2C7B6E616D653A2266612D68616E642D6F2D646F776E222C66696C7465';
wwv_flow_imp.g_varchar2_table(391) := '72733A22706F696E74227D2C7B6E616D653A2266612D68616E642D6F2D6C656674222C66696C746572733A22706F696E742C6C6566742C70726576696F75732C6261636B227D2C7B6E616D653A2266612D68616E642D6F2D7269676874222C66696C7465';
wwv_flow_imp.g_varchar2_table(392) := '72733A22706F696E742C72696768742C6E6578742C666F7277617264227D2C7B6E616D653A2266612D68616E642D6F2D7570222C66696C746572733A22706F696E74227D2C7B6E616D653A2266612D6C6F6E672D6172726F772D646F776E227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(393) := '6D653A2266612D6C6F6E672D6172726F772D6C656674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D6C6F6E672D6172726F772D7269676874227D2C7B6E616D653A2266612D6C6F6E672D6172726F772D75';
wwv_flow_imp.g_varchar2_table(394) := '70227D2C7B6E616D653A2266612D706167652D626F74746F6D227D2C7B6E616D653A2266612D706167652D6669727374227D2C7B6E616D653A2266612D706167652D6C617374227D2C7B6E616D653A2266612D706167652D746F70227D5D2C4348415254';
wwv_flow_imp.g_varchar2_table(395) := '3A5B7B6E616D653A2266612D617265612D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D6261722D6368617274222C66696C746572733A2262617263686172746F2C67726170682C616E61';
wwv_flow_imp.g_varchar2_table(396) := '6C7974696373227D2C7B6E616D653A2266612D6261722D63686172742D686F72697A6F6E74616C227D2C7B6E616D653A2266612D626F782D706C6F742D6368617274227D2C7B6E616D653A2266612D627562626C652D6368617274227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(397) := '2266612D636F6D626F2D6368617274227D2C7B6E616D653A2266612D6469616C2D67617567652D6368617274227D2C7B6E616D653A2266612D646F6E75742D6368617274227D2C7B6E616D653A2266612D66756E6E656C2D6368617274227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(398) := '653A2266612D67616E74742D6368617274227D2C7B6E616D653A2266612D6C696E652D617265612D6368617274227D2C7B6E616D653A2266612D6C696E652D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(399) := '6D653A2266612D7069652D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D7069652D63686172742D30227D2C7B6E616D653A2266612D7069652D63686172742D3130227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(400) := '2266612D7069652D63686172742D313030227D2C7B6E616D653A2266612D7069652D63686172742D3135227D2C7B6E616D653A2266612D7069652D63686172742D3230227D2C7B6E616D653A2266612D7069652D63686172742D3235227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(401) := '3A2266612D7069652D63686172742D3330227D2C7B6E616D653A2266612D7069652D63686172742D3335227D2C7B6E616D653A2266612D7069652D63686172742D3430227D2C7B6E616D653A2266612D7069652D63686172742D3435227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(402) := '3A2266612D7069652D63686172742D35227D2C7B6E616D653A2266612D7069652D63686172742D3530227D2C7B6E616D653A2266612D7069652D63686172742D3535227D2C7B6E616D653A2266612D7069652D63686172742D3630227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(403) := '2266612D7069652D63686172742D3635227D2C7B6E616D653A2266612D7069652D63686172742D3730227D2C7B6E616D653A2266612D7069652D63686172742D3735227D2C7B6E616D653A2266612D7069652D63686172742D3830227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(404) := '2266612D7069652D63686172742D3835227D2C7B6E616D653A2266612D7069652D63686172742D3930227D2C7B6E616D653A2266612D7069652D63686172742D3935227D2C7B6E616D653A2266612D706F6C61722D6368617274227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(405) := '66612D707972616D69642D6368617274227D2C7B6E616D653A2266612D72616461722D6368617274227D2C7B6E616D653A2266612D72616E67652D63686172742D61726561227D2C7B6E616D653A2266612D72616E67652D63686172742D626172227D2C';
wwv_flow_imp.g_varchar2_table(406) := '7B6E616D653A2266612D736361747465722D6368617274227D2C7B6E616D653A2266612D73746F636B2D6368617274227D2C7B6E616D653A2266612D782D61786973227D2C7B6E616D653A2266612D792D61786973227D2C7B6E616D653A2266612D7931';
wwv_flow_imp.g_varchar2_table(407) := '2D61786973227D2C7B6E616D653A2266612D79322D61786973227D5D2C564944454F5F504C415945523A5B7B6E616D653A2266612D6172726F77732D616C74222C66696C746572733A22657870616E642C656E6C617267652C66756C6C73637265656E2C';
wwv_flow_imp.g_varchar2_table(408) := '6269676765722C6D6F76652C72656F726465722C726573697A65227D2C7B6E616D653A2266612D6261636B77617264222C66696C746572733A22726577696E642C70726576696F7573227D2C7B6E616D653A2266612D636F6D7072657373222C66696C74';
wwv_flow_imp.g_varchar2_table(409) := '6572733A22636F6C6C617073652C636F6D62696E652C636F6E74726163742C6D657267652C736D616C6C6572227D2C7B6E616D653A2266612D656A656374227D2C7B6E616D653A2266612D657870616E64222C66696C746572733A22656E6C617267652C';
wwv_flow_imp.g_varchar2_table(410) := '6269676765722C726573697A65227D2C7B6E616D653A2266612D666173742D6261636B77617264222C66696C746572733A22726577696E642C70726576696F75732C626567696E6E696E672C73746172742C6669727374227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(411) := '666173742D666F7277617264222C66696C746572733A226E6578742C656E642C6C617374227D2C7B6E616D653A2266612D666F7277617264222C66696C746572733A22666F72776172642C6E657874227D2C7B6E616D653A2266612D7061757365222C66';
wwv_flow_imp.g_varchar2_table(412) := '696C746572733A2277616974227D2C7B6E616D653A2266612D70617573652D636972636C65227D2C7B6E616D653A2266612D70617573652D636972636C652D6F227D2C7B6E616D653A2266612D706C6179222C66696C746572733A2273746172742C706C';
wwv_flow_imp.g_varchar2_table(413) := '6179696E672C6D757369632C736F756E64227D2C7B6E616D653A2266612D706C61792D636972636C65222C66696C746572733A2273746172742C706C6179696E67227D2C7B6E616D653A2266612D706C61792D636972636C652D6F227D2C7B6E616D653A';
wwv_flow_imp.g_varchar2_table(414) := '2266612D72616E646F6D222C66696C746572733A22736F72742C73687566666C65227D2C7B6E616D653A2266612D737465702D6261636B77617264222C66696C746572733A22726577696E642C70726576696F75732C626567696E6E696E672C73746172';
wwv_flow_imp.g_varchar2_table(415) := '742C6669727374227D2C7B6E616D653A2266612D737465702D666F7277617264222C66696C746572733A226E6578742C656E642C6C617374227D2C7B6E616D653A2266612D73746F70222C66696C746572733A22626C6F636B2C626F782C737175617265';
wwv_flow_imp.g_varchar2_table(416) := '227D2C7B6E616D653A2266612D73746F702D636972636C65227D2C7B6E616D653A2266612D73746F702D636972636C652D6F227D5D2C454D4F4A493A5B7B6E616D653A2266612D617765736F6D652D66616365227D2C7B6E616D653A2266612D656D6F6A';
wwv_flow_imp.g_varchar2_table(417) := '692D616E677279227D2C7B6E616D653A2266612D656D6F6A692D6173746F6E6973686564227D2C7B6E616D653A2266612D656D6F6A692D6269672D657965732D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D6269672D66726F776E227D2C';
wwv_flow_imp.g_varchar2_table(418) := '7B6E616D653A2266612D656D6F6A692D636F6C642D7377656174227D2C7B6E616D653A2266612D656D6F6A692D636F6E666F756E646564227D2C7B6E616D653A2266612D656D6F6A692D636F6E6675736564227D2C7B6E616D653A2266612D656D6F6A69';
wwv_flow_imp.g_varchar2_table(419) := '2D636F6F6C227D2C7B6E616D653A2266612D656D6F6A692D6372696E6765227D2C7B6E616D653A2266612D656D6F6A692D637279227D2C7B6E616D653A2266612D656D6F6A692D64656C6963696F7573227D2C7B6E616D653A2266612D656D6F6A692D64';
wwv_flow_imp.g_varchar2_table(420) := '69736170706F696E746564227D2C7B6E616D653A2266612D656D6F6A692D6469736170706F696E7465642D72656C6965766564227D2C7B6E616D653A2266612D656D6F6A692D65787072657373696F6E6C657373227D2C7B6E616D653A2266612D656D6F';
wwv_flow_imp.g_varchar2_table(421) := '6A692D6665617266756C227D2C7B6E616D653A2266612D656D6F6A692D66726F776E227D2C7B6E616D653A2266612D656D6F6A692D6772696D616365227D2C7B6E616D653A2266612D656D6F6A692D6772696E2D7377656174227D2C7B6E616D653A2266';
wwv_flow_imp.g_varchar2_table(422) := '612D656D6F6A692D68617070792D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D687573686564227D2C7B6E616D653A2266612D656D6F6A692D6C61756768696E67227D2C7B6E616D653A2266612D656D6F6A692D6C6F6C227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(423) := '653A2266612D656D6F6A692D6C6F7665227D2C7B6E616D653A2266612D656D6F6A692D6D65616E227D2C7B6E616D653A2266612D656D6F6A692D6E657264227D2C7B6E616D653A2266612D656D6F6A692D6E65757472616C227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(424) := '2D656D6F6A692D6E6F2D6D6F757468227D2C7B6E616D653A2266612D656D6F6A692D6F70656E2D6D6F757468227D2C7B6E616D653A2266612D656D6F6A692D70656E73697665227D2C7B6E616D653A2266612D656D6F6A692D706572736576657265227D';
wwv_flow_imp.g_varchar2_table(425) := '2C7B6E616D653A2266612D656D6F6A692D706C6561736564227D2C7B6E616D653A2266612D656D6F6A692D72656C6965766564227D2C7B6E616D653A2266612D656D6F6A692D726F74666C227D2C7B6E616D653A2266612D656D6F6A692D73637265616D';
wwv_flow_imp.g_varchar2_table(426) := '227D2C7B6E616D653A2266612D656D6F6A692D736C656570696E67227D2C7B6E616D653A2266612D656D6F6A692D736C65657079227D2C7B6E616D653A2266612D656D6F6A692D736C696768742D66726F776E227D2C7B6E616D653A2266612D656D6F6A';
wwv_flow_imp.g_varchar2_table(427) := '692D736C696768742D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D736D69726B227D2C7B6E616D653A2266612D656D6F6A692D737475636B2D6F75742D746F6E677565227D2C';
wwv_flow_imp.g_varchar2_table(428) := '7B6E616D653A2266612D656D6F6A692D737475636B2D6F75742D746F6E6775652D636C6F7365642D65796573227D2C7B6E616D653A2266612D656D6F6A692D737475636B2D6F75742D746F6E6775652D77696E6B227D2C7B6E616D653A2266612D656D6F';
wwv_flow_imp.g_varchar2_table(429) := '6A692D73776565742D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D7469726564227D2C7B6E616D653A2266612D656D6F6A692D756E616D75736564227D2C7B6E616D653A2266612D656D6F6A692D7570736964652D646F776E227D2C7B6E';
wwv_flow_imp.g_varchar2_table(430) := '616D653A2266612D656D6F6A692D7765617279227D2C7B6E616D653A2266612D656D6F6A692D77696E6B227D2C7B6E616D653A2266612D656D6F6A692D776F727279227D2C7B6E616D653A2266612D656D6F6A692D7A69707065722D6D6F757468227D2C';
wwv_flow_imp.g_varchar2_table(431) := '7B6E616D653A2266612D68697073746572227D5D2C43555252454E43593A5B7B6E616D653A2266612D626974636F696E227D2C7B6E616D653A2266612D627463227D2C7B6E616D653A2266612D636E79222C66696C746572733A226368696E612C72656E';
wwv_flow_imp.g_varchar2_table(432) := '6D696E62692C7975616E227D2C7B6E616D653A2266612D646F6C6C6172222C66696C746572733A22757364227D2C7B6E616D653A2266612D657572222C66696C746572733A226575726F227D2C7B6E616D653A2266612D6575726F222C66696C74657273';
wwv_flow_imp.g_varchar2_table(433) := '3A226575726F227D2C7B6E616D653A2266612D676270227D2C7B6E616D653A2266612D696C73222C66696C746572733A227368656B656C2C73686571656C227D2C7B6E616D653A2266612D696E72222C66696C746572733A227275706565227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(434) := '6D653A2266612D6A7079222C66696C746572733A226A6170616E2C79656E227D2C7B6E616D653A2266612D6B7277222C66696C746572733A22776F6E227D2C7B6E616D653A2266612D6D6F6E6579222C66696C746572733A22636173682C6D6F6E65792C';
wwv_flow_imp.g_varchar2_table(435) := '6275792C636865636B6F75742C70757263686173652C7061796D656E74227D2C7B6E616D653A2266612D726D62222C66696C746572733A226368696E612C72656E6D696E62692C7975616E227D2C7B6E616D653A2266612D727562222C66696C74657273';
wwv_flow_imp.g_varchar2_table(436) := '3A227275626C652C726F75626C65227D2C7B6E616D653A2266612D747279222C66696C746572733A227475726B65792C206C6972612C207475726B697368227D2C7B6E616D653A2266612D757364222C66696C746572733A22646F6C6C6172227D2C7B6E';
wwv_flow_imp.g_varchar2_table(437) := '616D653A2266612D79656E227D5D2C43414C454E4441523A5B7B6E616D653A2266612D63616C656E6461722D616C61726D227D2C7B6E616D653A2266612D63616C656E6461722D6172726F772D646F776E227D2C7B6E616D653A2266612D63616C656E64';
wwv_flow_imp.g_varchar2_table(438) := '61722D6172726F772D7570227D2C7B6E616D653A2266612D63616C656E6461722D62616E227D2C7B6E616D653A2266612D63616C656E6461722D6368617274227D2C7B6E616D653A2266612D63616C656E6461722D636C6F636B222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(439) := '22686973746F7279227D2C7B6E616D653A2266612D63616C656E6461722D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D63616C656E6461722D6865617274222C66696C746572733A226C696B652C6661766F7269';
wwv_flow_imp.g_varchar2_table(440) := '7465227D2C7B6E616D653A2266612D63616C656E6461722D6C6F636B227D2C7B6E616D653A2266612D63616C656E6461722D706F696E746572227D2C7B6E616D653A2266612D63616C656E6461722D736561726368227D2C7B6E616D653A2266612D6361';
wwv_flow_imp.g_varchar2_table(441) := '6C656E6461722D75736572227D2C7B6E616D653A2266612D63616C656E6461722D7772656E6368227D5D2C464F524D5F434F4E54524F4C3A5B7B6E616D653A2266612D636865636B2D737175617265222C66696C746572733A22636865636B6D61726B2C';
wwv_flow_imp.g_varchar2_table(442) := '646F6E652C746F646F2C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D7371756172652D6F222C66696C746572733A22746F646F2C646F6E652C61677265652C6163636570742C636F6E6669726D227D';
wwv_flow_imp.g_varchar2_table(443) := '2C7B6E616D653A2266612D636972636C65222C66696C746572733A22646F742C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D636972636C652D6F227D2C7B6E616D653A2266612D646F742D636972636C652D6F222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(444) := '227461726765742C62756C6C736579652C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D6D696E75732D737175617265222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964';
wwv_flow_imp.g_varchar2_table(445) := '652C636F6C6C61707365227D2C7B6E616D653A2266612D6D696E75732D7371756172652D6F222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964652C636F6C6C61707365227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(446) := '653A2266612D706C75732D737175617265222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706C75732D7371756172652D6F222C66696C746572733A226164642C6E65772C637265617465';
wwv_flow_imp.g_varchar2_table(447) := '2C657870616E64227D2C7B6E616D653A2266612D737175617265222C66696C746572733A22626C6F636B2C626F78227D2C7B6E616D653A2266612D7371756172652D6F222C66696C746572733A22626C6F636B2C7371756172652C626F78227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(448) := '6D653A2266612D7371756172652D73656C65637465642D6F222C66696C746572733A22626C6F636B2C7371756172652C626F78227D2C7B6E616D653A2266612D74696D65732D737175617265222C66696C746572733A2272656D6F76652C636C6F73652C';
wwv_flow_imp.g_varchar2_table(449) := '636C6F73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D74696D65732D7371756172652D6F222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D5D2C5350494E4E45523A5B';
wwv_flow_imp.g_varchar2_table(450) := '7B6E616D653A2266612D636972636C652D6F2D6E6F746368227D2C7B6E616D653A2266612D67656172222C66696C746572733A2273657474696E67732C636F67227D2C7B6E616D653A2266612D72656672657368222C66696C746572733A2272656C6F61';
wwv_flow_imp.g_varchar2_table(451) := '642C73796E63227D2C7B6E616D653A2266612D7370696E6E6572222C66696C746572733A226C6F6164696E672C70726F6772657373227D5D2C5041594D454E543A5B7B6E616D653A2266612D6372656469742D63617264222C66696C746572733A226D6F';
wwv_flow_imp.g_varchar2_table(452) := '6E65792C6275792C64656269742C636865636B6F75742C70757263686173652C7061796D656E74227D2C7B6E616D653A2266612D6372656469742D636172642D616C74227D2C7B6E616D653A2266612D6372656469742D636172642D7465726D696E616C';
wwv_flow_imp.g_varchar2_table(453) := '227D5D2C46494C455F545950453A5B7B6E616D653A2266612D66696C65222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D617263686976652D6F222C66696C746572733A227A';
wwv_flow_imp.g_varchar2_table(454) := '6970227D2C7B6E616D653A2266612D66696C652D617564696F2D6F222C66696C746572733A22736F756E64227D2C7B6E616D653A2266612D66696C652D636F64652D6F227D2C7B6E616D653A2266612D66696C652D657863656C2D6F227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(455) := '3A2266612D66696C652D696D6167652D6F222C66696C746572733A2270686F746F2C70696374757265227D2C7B6E616D653A2266612D66696C652D6F222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(456) := '3A2266612D66696C652D7064662D6F227D2C7B6E616D653A2266612D66696C652D706F776572706F696E742D6F227D2C7B6E616D653A2266612D66696C652D73716C2D6F227D2C7B6E616D653A2266612D66696C652D74657874222C66696C746572733A';
wwv_flow_imp.g_varchar2_table(457) := '226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D746578742D6F222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D76696465';
wwv_flow_imp.g_varchar2_table(458) := '6F2D6F222C66696C746572733A2266696C656D6F7669656F227D2C7B6E616D653A2266612D66696C652D776F72642D6F227D5D2C47454E4445523A5B7B6E616D653A2266612D67656E6465726C657373227D2C7B6E616D653A2266612D6D617273222C66';
wwv_flow_imp.g_varchar2_table(459) := '696C746572733A226D616C65227D2C7B6E616D653A2266612D6D6172732D646F75626C65227D2C7B6E616D653A2266612D6D6172732D7374726F6B65227D2C7B6E616D653A2266612D6D6172732D7374726F6B652D68227D2C7B6E616D653A2266612D6D';
wwv_flow_imp.g_varchar2_table(460) := '6172732D7374726F6B652D76227D2C7B6E616D653A2266612D6D657263757279222C66696C746572733A227472616E7367656E646572227D2C7B6E616D653A2266612D6E6575746572227D2C7B6E616D653A2266612D7472616E7367656E646572222C66';
wwv_flow_imp.g_varchar2_table(461) := '696C746572733A22696E746572736578227D2C7B6E616D653A2266612D7472616E7367656E6465722D616C74227D2C7B6E616D653A2266612D76656E7573222C66696C746572733A2266656D616C65227D2C7B6E616D653A2266612D76656E75732D646F';
wwv_flow_imp.g_varchar2_table(462) := '75626C65227D2C7B6E616D653A2266612D76656E75732D6D617273227D5D2C48414E443A5B7B6E616D653A2266612D68616E642D677261622D6F222C66696C746572733A2268616E6420726F636B227D2C7B6E616D653A2266612D68616E642D6C697A61';
wwv_flow_imp.g_varchar2_table(463) := '72642D6F227D2C7B6E616D653A2266612D68616E642D6F2D646F776E222C66696C746572733A22706F696E74227D2C7B6E616D653A2266612D68616E642D6F2D6C656674222C66696C746572733A22706F696E742C6C6566742C70726576696F75732C62';
wwv_flow_imp.g_varchar2_table(464) := '61636B227D2C7B6E616D653A2266612D68616E642D6F2D7269676874222C66696C746572733A22706F696E742C72696768742C6E6578742C666F7277617264227D2C7B6E616D653A2266612D68616E642D6F2D7570222C66696C746572733A22706F696E';
wwv_flow_imp.g_varchar2_table(465) := '74227D2C7B6E616D653A2266612D68616E642D70656163652D6F227D2C7B6E616D653A2266612D68616E642D706F696E7465722D6F227D2C7B6E616D653A2266612D68616E642D73636973736F72732D6F227D2C7B6E616D653A2266612D68616E642D73';
wwv_flow_imp.g_varchar2_table(466) := '706F636B2D6F227D2C7B6E616D653A2266612D68616E642D73746F702D6F222C66696C746572733A2268616E64207061706572227D2C7B6E616D653A2266612D7468756D62732D646F776E222C66696C746572733A226469736C696B652C646973617070';
wwv_flow_imp.g_varchar2_table(467) := '726F76652C64697361677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D6F2D646F776E222C66696C746572733A226469736C696B652C646973617070726F76652C64697361677265652C68616E64227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(468) := '7468756D62732D6F2D7570222C66696C746572733A226C696B652C617070726F76652C6661766F726974652C61677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D7570222C66696C746572733A226C696B652C6661766F72697465';
wwv_flow_imp.g_varchar2_table(469) := '2C617070726F76652C61677265652C68616E64227D5D2C4E554D424552533A5B7B6E616D653A2266612D6E756D6265722D30227D2C7B6E616D653A2266612D6E756D6265722D302D6F227D2C7B6E616D653A2266612D6E756D6265722D31227D2C7B6E61';
wwv_flow_imp.g_varchar2_table(470) := '6D653A2266612D6E756D6265722D312D6F227D2C7B6E616D653A2266612D6E756D6265722D32227D2C7B6E616D653A2266612D6E756D6265722D322D6F227D2C7B6E616D653A2266612D6E756D6265722D33227D2C7B6E616D653A2266612D6E756D6265';
wwv_flow_imp.g_varchar2_table(471) := '722D332D6F227D2C7B6E616D653A2266612D6E756D6265722D34227D2C7B6E616D653A2266612D6E756D6265722D342D6F227D2C7B6E616D653A2266612D6E756D6265722D35227D2C7B6E616D653A2266612D6E756D6265722D352D6F227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(472) := '653A2266612D6E756D6265722D36227D2C7B6E616D653A2266612D6E756D6265722D362D6F227D2C7B6E616D653A2266612D6E756D6265722D37227D2C7B6E616D653A2266612D6E756D6265722D372D6F227D2C7B6E616D653A2266612D6E756D626572';
wwv_flow_imp.g_varchar2_table(473) := '2D38227D2C7B6E616D653A2266612D6E756D6265722D382D6F227D2C7B6E616D653A2266612D6E756D6265722D39227D2C7B6E616D653A2266612D6E756D6265722D392D6F227D5D2C4D4150533A5B7B6E616D653A2266612D6D61702D70696E2D747269';
wwv_flow_imp.g_varchar2_table(474) := '616E676C65222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D747261666669632D6C696768742D73746F70222C66696C7465';
wwv_flow_imp.g_varchar2_table(475) := '72733A2273746F702C676F2C7369676E227D2C7B6E616D653A2266612D6D61702D70696E2D6865617274222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E7322';
wwv_flow_imp.g_varchar2_table(476) := '7D2C7B6E616D653A2266612D6D61702D70696E2D68656172742D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D6D6170';
wwv_flow_imp.g_varchar2_table(477) := '2D70696E2D636972636C65222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D6D61702D70696E2D636972636C652D6F222C66';
wwv_flow_imp.g_varchar2_table(478) := '696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D6D61702D6D61726B657273222C66696C746572733A2270696E2C6E617669676174';
wwv_flow_imp.g_varchar2_table(479) := '696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D6D61702D6D61726B6572732D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C77617920';
wwv_flow_imp.g_varchar2_table(480) := '66696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D6D61702D6D61726B65722D736C617368222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374';
wwv_flow_imp.g_varchar2_table(481) := '696F6E73227D2C7B6E616D653A2266612D6D61702D6D61726B65722D736C6173682D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D65';
wwv_flow_imp.g_varchar2_table(482) := '3A2266612D6D61702D6D61726B65722D7368696E65222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C686967686C69676874227D2C7B6E616D653A226661';
wwv_flow_imp.g_varchar2_table(483) := '2D6D61702D6D61726B65722D7368696E652D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C686967686C69676874227D2C7B6E616D653A2266612D6D';
wwv_flow_imp.g_varchar2_table(484) := '61702D6D61726B65722D666163652D66726F776E222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C656D6F6A692C736164227D2C7B6E616D653A2266612D';
wwv_flow_imp.g_varchar2_table(485) := '6D61702D6D61726B65722D666163652D66726F776E2D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C656D6F6A692C736164227D2C7B6E616D653A22';
wwv_flow_imp.g_varchar2_table(486) := '66612D6D61702D6D61726B65722D666163652D6D6568222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C656D6F6A692C6E65757472616C227D2C7B6E616D';
wwv_flow_imp.g_varchar2_table(487) := '653A2266612D6D61702D6D61726B65722D666163652D6D65682D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C656D6F6A692C6E65757472616C227D';
wwv_flow_imp.g_varchar2_table(488) := '2C7B6E616D653A2266612D6D61702D6D61726B65722D666163652D736D696C65222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C656D6F6A692C68617070';
wwv_flow_imp.g_varchar2_table(489) := '79227D2C7B6E616D653A2266612D6D61702D6D61726B65722D666163652D736D696C652D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C656D6F6A69';
wwv_flow_imp.g_varchar2_table(490) := '2C6861707079227D2C7B6E616D653A2266612D6D61702D6D61726B65722D63616D6572612D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E732C70686F74';
wwv_flow_imp.g_varchar2_table(491) := '6F2C70686F746F677261706879227D2C7B6E616D653A2266612D6D61702D6D61726B65722D63616D657261222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73';
wwv_flow_imp.g_varchar2_table(492) := '2C70686F746F2C70686F746F677261706879227D2C7B6E616D653A2266612D6D61702D6D61726B6572222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D';
wwv_flow_imp.g_varchar2_table(493) := '2C7B6E616D653A2266612D6D61702D6D61726B65722D636865636B2D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D6D';
wwv_flow_imp.g_varchar2_table(494) := '61702D6D61726B65722D636865636B222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E73227D2C7B6E616D653A2266612D6C696E652D6D6170222C66696C7465';
wwv_flow_imp.g_varchar2_table(495) := '72733A22726F61642C747261696E2C737562776179227D2C7B6E616D653A2266612D32642D6D6F6465222C66696C746572733A226D6170732C6D6F64652C32642C3364227D2C7B6E616D653A2266612D33642D6D6F6465222C66696C746572733A226D61';
wwv_flow_imp.g_varchar2_table(496) := '70732C6D6F64652C32642C3364227D2C7B6E616D653A2266612D6C6F636174696F6E222C66696C746572733A226D61702C63726F73736861697273227D2C7B6E616D653A2266612D6C6F636174696F6E2D736C617368222C66696C746572733A226D6170';
wwv_flow_imp.g_varchar2_table(497) := '2C63726F73736861697273227D2C7B6E616D653A2266612D6D61702D70696E2D747269616E676C652D6F222C66696C746572733A2270696E2C6E617669676174696F6E2C6C6F636174696F6E2C7761792066696E64696E672C646972656374696F6E7322';
wwv_flow_imp.g_varchar2_table(498) := '7D2C7B6E616D653A2266612D747261666669632D6C696768742D676F222C66696C746572733A2273746F702C676F2C7369676E227D2C7B6E616D653A2266612D747261666669632D6C69676874222C66696C746572733A2273746F702C676F2C7369676E';
wwv_flow_imp.g_varchar2_table(499) := '227D2C7B6E616D653A2266612D6C6F636174696F6E2D636972636C65222C66696C746572733A226E617669676174696F6E2C6D61702C7761792066696E64696E672C636F6D706173732C646972656374696F6E227D2C7B6E616D653A2266612D6C6F6361';
wwv_flow_imp.g_varchar2_table(500) := '74696F6E2D636972636C652D6F222C66696C746572733A226E617669676174696F6E2C6D61702C7761792066696E64696E672C636F6D706173732C646972656374696F6E227D2C7B6E616D653A2266612D6C6F636174696F6E2D6172726F77222C66696C';
wwv_flow_imp.g_varchar2_table(501) := '746572733A226E617669676174696F6E2C6D61702C7761792066696E64696E672C636F6D706173732C646972656374696F6E227D5D7D7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(132675384720225864)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_file_name=>'js/IPicons.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '402D6D732D76696577706F72747B77696474683A6465766963652D77696474687D402D6F2D76696577706F72747B77696474683A6465766963652D77696474687D4076696577706F72747B77696474683A6465766963652D77696474687D68746D6C7B62';
wwv_flow_imp.g_varchar2_table(2) := '6F782D73697A696E673A626F726465722D626F787D2A2C2A203A3A61667465722C2A203A3A6265666F72657B626F782D73697A696E673A696E68657269747D68746D6C7B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C696173';
wwv_flow_imp.g_varchar2_table(3) := '65643B2D6D732D6F766572666C6F772D7374796C653A7363726F6C6C6261723B2D7765626B69742D7461702D686967686C696768742D636F6C6F723A7472616E73706172656E743B2D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A67726179';
wwv_flow_imp.g_varchar2_table(4) := '7363616C657D626F64797B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B6D617267696E3A303B70616464696E673A303B6D696E2D77696474683A33323070783B6D696E2D6865696768743A313030253B6D696E';
wwv_flow_imp.g_varchar2_table(5) := '2D6865696768743A31303076683B666F6E742D73697A653A313670783B666F6E742D66616D696C793A2D6170706C652D73797374656D2C426C696E6B4D616353797374656D466F6E742C225365676F65205549222C526F626F746F2C4F787967656E2C55';
wwv_flow_imp.g_varchar2_table(6) := '62756E74752C43616E746172656C6C2C22466972612053616E73222C2244726F69642053616E73222C2248656C766574696361204E657565222C73616E732D73657269663B6C696E652D6865696768743A312E353B6261636B67726F756E642D636F6C6F';
wwv_flow_imp.g_varchar2_table(7) := '723A236637663766377D617B746578742D6465636F726174696F6E3A6E6F6E653B636F6C6F723A233035373263657D613A6E6F74285B636C6173735D293A686F7665727B746578742D6465636F726174696F6E3A756E6465726C696E657D707B6D617267';
wwv_flow_imp.g_varchar2_table(8) := '696E3A30203020323470787D703A6C6173742D6368696C647B6D617267696E2D626F74746F6D3A307D68317B6D617267696E3A30203020313670783B666F6E742D73697A653A343870787D68327B6D617267696E3A30203020313270783B666F6E742D73';
wwv_flow_imp.g_varchar2_table(9) := '697A653A333270787D68337B6D617267696E3A302030203870783B666F6E742D73697A653A323470787D68347B6D617267696E2D626F74746F6D3A3470783B666F6E742D73697A653A323070787D636F64652C7072657B666F6E742D73697A653A393025';
wwv_flow_imp.g_varchar2_table(10) := '3B666F6E742D66616D696C793A53464D6F6E6F2D526567756C61722C4D656E6C6F2C4D6F6E61636F2C436F6E736F6C61732C224C696265726174696F6E204D6F6E6F222C22436F7572696572204E6577222C6D6F6E6F73706163653B6261636B67726F75';
wwv_flow_imp.g_varchar2_table(11) := '6E642D636F6C6F723A7267626128302C302C302C2E303235293B626F782D736861646F773A696E736574207267626128302C302C302C2E303529203020302030203170787D636F64657B70616464696E673A327078203470783B626F726465722D726164';
wwv_flow_imp.g_varchar2_table(12) := '6975733A3270787D7072657B70616464696E673A3870783B626F726465722D7261646975733A3470783B6D617267696E2D626F74746F6D3A313670787D2E69636F6E2D636C6173737B636F6C6F723A233137373536637D2E6D6F6469666965722D636C61';
wwv_flow_imp.g_varchar2_table(13) := '73737B636F6C6F723A233963323762307D2E646D2D41636365737369626C6548696464656E7B706F736974696F6E3A6162736F6C7574653B6C6566743A2D313030303070783B746F703A6175746F3B77696474683A3170783B6865696768743A3170783B';
wwv_flow_imp.g_varchar2_table(14) := '6F766572666C6F773A68696464656E7D2E646D2D4865616465727B636F6C6F723A236666663B6261636B67726F756E642D636F6C6F723A233035373263653B666C65782D67726F773A307D2E646D2D4865616465723E2E646D2D436F6E7461696E65727B';
wwv_flow_imp.g_varchar2_table(15) := '646973706C61793A666C65783B70616464696E672D746F703A313670783B70616464696E672D626F74746F6D3A313670787D406D656469612073637265656E20616E6420286D61782D77696474683A3736377078297B2E646D2D4865616465723E2E646D';
wwv_flow_imp.g_varchar2_table(16) := '2D436F6E7461696E65727B70616464696E672D746F703A3470783B70616464696E672D626F74746F6D3A3470787D7D2E646D2D4865616465722D6C6F676F4C696E6B7B646973706C61793A696E6C696E652D666C65783B766572746963616C2D616C6967';
wwv_flow_imp.g_varchar2_table(17) := '6E3A746F703B746578742D6465636F726174696F6E3A6E6F6E653B636F6C6F723A236666663B616C69676E2D73656C663A63656E7465727D2E646D2D4865616465722D6C6F676F49636F6E7B646973706C61793A626C6F636B3B6D617267696E2D726967';
wwv_flow_imp.g_varchar2_table(18) := '68743A3470783B77696474683A31323870783B6865696768743A343870783B66696C6C3A63757272656E74436F6C6F723B2D6D732D677269642D726F772D616C69676E3A63656E7465723B616C69676E2D73656C663A63656E7465727D2E646D2D486561';
wwv_flow_imp.g_varchar2_table(19) := '6465722D6C6F676F4C6162656C7B666F6E742D7765696768743A3530303B666F6E742D73697A653A313470783B2D6D732D677269642D726F772D616C69676E3A63656E7465723B616C69676E2D73656C663A63656E7465727D406D656469612073637265';
wwv_flow_imp.g_varchar2_table(20) := '656E20616E6420286D696E2D77696474683A3336307078297B2E646D2D4865616465722D6C6F676F49636F6E7B6D617267696E2D72696768743A3870787D2E646D2D4865616465722D6C6F676F4C6162656C7B666F6E742D73697A653A313670787D7D2E';
wwv_flow_imp.g_varchar2_table(21) := '646D2D4865616465724E61767B6D617267696E3A303B6D617267696E2D6C6566743A6175746F3B70616464696E673A303B6C6973742D7374796C653A6E6F6E653B2D6D732D677269642D726F772D616C69676E3A63656E7465723B616C69676E2D73656C';
wwv_flow_imp.g_varchar2_table(22) := '663A63656E7465727D2E646D2D4865616465724E6176206C697B646973706C61793A696E6C696E652D626C6F636B3B766572746963616C2D616C69676E3A746F707D2E646D2D4865616465724E61762D6C696E6B7B646973706C61793A696E6C696E652D';
wwv_flow_imp.g_varchar2_table(23) := '626C6F636B3B6D617267696E2D6C6566743A6175746F3B70616464696E673A3870783B766572746963616C2D616C69676E3A746F703B77686974652D73706163653A6E6F777261703B666F6E742D73697A653A313470783B6C696E652D6865696768743A';
wwv_flow_imp.g_varchar2_table(24) := '313670783B636F6C6F723A236666663B636F6C6F723A72676261283235352C3235352C3235352C2E3935293B626F726465722D7261646975733A3470783B626F782D736861646F773A696E7365742072676261283235352C3235352C3235352C2E323529';
wwv_flow_imp.g_varchar2_table(25) := '203020302030203170787D406D656469612073637265656E20616E6420286D696E2D77696474683A3336307078297B2E646D2D4865616465724E61762D6C696E6B7B70616464696E673A38707820313270787D7D2E646D2D4865616465724E61762D6C69';
wwv_flow_imp.g_varchar2_table(26) := '6E6B3A686F7665727B636F6C6F723A236666663B626F782D736861646F773A696E7365742023666666203020302030203170787D2E646D2D4865616465724E61762D69636F6E7B646973706C61793A696E6C696E652D626C6F636B3B77696474683A3136';
wwv_flow_imp.g_varchar2_table(27) := '70783B6865696768743A313670783B766572746963616C2D616C69676E3A746F703B666F6E742D73697A653A3136707821696D706F7274616E743B6C696E652D6865696768743A3136707821696D706F7274616E743B66696C6C3A63757272656E74436F';
wwv_flow_imp.g_varchar2_table(28) := '6C6F727D2E646D2D4865616465724E61762D6C6162656C7B6D617267696E2D6C6566743A3270787D406D656469612073637265656E20616E6420286D61782D77696474683A3736377078297B2E646D2D4865616465724E61762D6C6162656C7B64697370';
wwv_flow_imp.g_varchar2_table(29) := '6C61793A6E6F6E657D7D2E646D2D426F64797B70616464696E672D746F703A3870783B70616464696E672D626F74746F6D3A333270783B666C65782D67726F773A313B666C65782D736872696E6B3A313B666C65782D62617369733A6175746F7D2E646D';
wwv_flow_imp.g_varchar2_table(30) := '2D436F6E7461696E65727B6D617267696E2D72696768743A6175746F3B6D617267696E2D6C6566743A6175746F3B70616464696E672D72696768743A313670783B70616464696E672D6C6566743A313670783B6D61782D77696474683A3130323470787D';
wwv_flow_imp.g_varchar2_table(31) := '2E646D2D466F6F7465727B70616464696E672D746F703A333270783B70616464696E672D626F74746F6D3A333270783B666F6E742D73697A653A313270783B636F6C6F723A72676261283235352C3235352C3235352C2E3535293B6261636B67726F756E';
wwv_flow_imp.g_varchar2_table(32) := '642D636F6C6F723A233238326433313B666C65782D67726F773A303B746578742D616C69676E3A63656E7465727D2E646D2D466F6F74657220617B636F6C6F723A236666667D2E646D2D466F6F74657220707B6D617267696E3A307D2E646D2D466F6F74';
wwv_flow_imp.g_varchar2_table(33) := '657220703A6E6F74283A66697273742D6368696C64297B6D617267696E2D746F703A3870787D2E646D2D41626F75747B6D617267696E2D626F74746F6D3A363470787D2E646D2D496E74726F7B746578742D616C69676E3A63656E7465727D2E646D2D49';
wwv_flow_imp.g_varchar2_table(34) := '6E74726F2D69636F6E7B6D617267696E2D746F703A2D363470783B6D617267696E2D72696768743A6175746F3B6D617267696E2D626F74746F6D3A323470783B6D617267696E2D6C6566743A6175746F3B70616464696E673A333270783B77696474683A';
wwv_flow_imp.g_varchar2_table(35) := '31323870783B6865696768743A31323870783B636F6C6F723A233035373263653B6261636B67726F756E642D636F6C6F723A236666663B626F726465722D7261646975733A313030253B626F782D736861646F773A7267626128302C302C302C2E312920';
wwv_flow_imp.g_varchar2_table(36) := '302038707820333270787D406D656469612073637265656E20616E6420286D61782D77696474683A3736377078297B2E646D2D496E74726F2D69636F6E7B6D617267696E2D746F703A307D7D2E646D2D496E74726F2D69636F6E207376677B646973706C';
wwv_flow_imp.g_varchar2_table(37) := '61793A626C6F636B3B77696474683A363470783B6865696768743A363470783B66696C6C3A63757272656E74636F6C6F727D2E646D2D496E74726F2068317B6D617267696E2D626F74746F6D3A3870783B666F6E742D7765696768743A3730303B666F6E';
wwv_flow_imp.g_varchar2_table(38) := '742D73697A653A343070783B6C696E652D6865696768743A343870787D2E646D2D496E74726F20707B6D617267696E3A30203020323470783B666F6E742D73697A653A313870783B6F7061636974793A2E36357D2E646D2D496E74726F20703A6C617374';
wwv_flow_imp.g_varchar2_table(39) := '2D6368696C647B6D617267696E2D626F74746F6D3A307D2E646D2D536561726368426F787B646973706C61793A666C65783B6D617267696E2D746F703A303B6D617267696E2D626F74746F6D3A313570787D2E646D2D536561726368426F782D73657474';
wwv_flow_imp.g_varchar2_table(40) := '696E67737B6D617267696E2D6C6566743A3570783B666C65782D67726F773A303B666C65782D736872696E6B3A303B666C65782D62617369733A6175746F3B2D6D732D677269642D726F772D616C69676E3A63656E7465723B616C69676E2D73656C663A';
wwv_flow_imp.g_varchar2_table(41) := '63656E7465727D2E646D2D536561726368426F782D777261707B706F736974696F6E3A72656C61746976653B666C65782D67726F773A313B666C65782D736872696E6B3A313B666C65782D62617369733A6175746F3B2D6D732D677269642D726F772D61';
wwv_flow_imp.g_varchar2_table(42) := '6C69676E3A63656E7465723B616C69676E2D73656C663A63656E7465727D2E646D2D536561726368426F782D69636F6E7B706F736974696F6E3A6162736F6C75746521696D706F7274616E743B746F703A3530253B6C6566743A313270783B666F6E742D';
wwv_flow_imp.g_varchar2_table(43) := '73697A653A3138707821696D706F7274616E743B6C696E652D6865696768743A313B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D353025293B7472616E73666F726D3A7472616E736C61746559282D353025297D2E646D2D';
wwv_flow_imp.g_varchar2_table(44) := '536561726368426F782D696E7075747B646973706C61793A626C6F636B3B6D617267696E3A303B70616464696E673A357078203570782035707820333570783B6865696768743A333070783B77696474683A3830253B666F6E742D7765696768743A3430';
wwv_flow_imp.g_varchar2_table(45) := '303B666F6E742D73697A653A323070783B636F6C6F723A233030303B6261636B67726F756E642D636F6C6F723A236666663B6F75746C696E653A303B626F726465723A31707820736F6C6964207267626128302C302C302C2E3135293B626F726465722D';
wwv_flow_imp.g_varchar2_table(46) := '7261646975733A3470783B2D7765626B69742D617070656172616E63653A6E6F6E653B2D6D6F7A2D617070656172616E63653A6E6F6E653B617070656172616E63653A6E6F6E657D2E646D2D536561726368426F782D696E7075743A666F6375737B626F';
wwv_flow_imp.g_varchar2_table(47) := '726465722D636F6C6F723A233035373263657D2E646D2D536561726368426F782D696E7075743A3A2D7765626B69742D7365617263682D6465636F726174696F6E7B2D7765626B69742D617070656172616E63653A6E6F6E657D406D6564696120736372';
wwv_flow_imp.g_varchar2_table(48) := '65656E20616E6420286D61782D77696474683A3437397078297B2E646D2D536561726368426F787B666C65782D646972656374696F6E3A636F6C756D6E3B77696474683A313030257D2E646D2D536561726368426F782D777261707B2D6D732D67726964';
wwv_flow_imp.g_varchar2_table(49) := '2D726F772D616C69676E3A6175746F3B616C69676E2D73656C663A6175746F7D2E646D2D536561726368426F782D73657474696E67737B6D617267696E2D746F703A3870783B6D617267696E2D6C6566743A303B2D6D732D677269642D726F772D616C69';
wwv_flow_imp.g_varchar2_table(50) := '676E3A6175746F3B616C69676E2D73656C663A6175746F7D7D2E646D2D5365617263682D63617465676F72797B6D617267696E2D626F74746F6D3A313670783B70616464696E673A313670783B6261636B67726F756E642D636F6C6F723A236666663B62';
wwv_flow_imp.g_varchar2_table(51) := '6F726465723A31707820736F6C6964207267626128302C302C302C2E3135293B626F726465722D7261646975733A3870787D2E646D2D5365617263682D63617465676F72793A6C6173742D6368696C647B6D617267696E2D626F74746F6D3A307D2E646D';
wwv_flow_imp.g_varchar2_table(52) := '2D5365617263682D7469746C657B6D617267696E3A303B746578742D616C69676E3A63656E7465723B746578742D7472616E73666F726D3A6361706974616C697A653B666F6E742D7765696768743A3530303B666F6E742D73697A653A323470783B6F70';
wwv_flow_imp.g_varchar2_table(53) := '61636974793A2E36357D2E646D2D5365617263682D6C6973743A6F6E6C792D6368696C647B6D617267696E3A3021696D706F7274616E747D2E646D2D5365617263682D6C6973747B646973706C61793A666C65783B6D617267696E3A3136707820302030';
wwv_flow_imp.g_varchar2_table(54) := '3B70616464696E673A303B6C6973742D7374796C653A6E6F6E653B666C65782D777261703A777261703B616C69676E2D6974656D733A666C65782D73746172743B6A7573746966792D636F6E74656E743A666C65782D73746172747D2E646D2D53656172';
wwv_flow_imp.g_varchar2_table(55) := '63682D6C6973743A656D7074797B646973706C61793A6E6F6E657D2E646D2D5365617263682D6C697374206C697B646973706C61793A696E6C696E652D626C6F636B3B77696474683A63616C6328313030252F32297D406D656469612073637265656E20';
wwv_flow_imp.g_varchar2_table(56) := '616E6420286D696E2D77696474683A3438307078297B2E646D2D5365617263682D6C697374206C697B77696474683A63616C6328313030252F34297D7D406D656469612073637265656E20616E6420286D696E2D77696474683A3736387078297B2E646D';
wwv_flow_imp.g_varchar2_table(57) := '2D5365617263682D6C697374206C697B77696474683A63616C632828313030252F3629202D202E317078297D7D406D656469612073637265656E20616E6420286D696E2D77696474683A313032347078297B2E646D2D5365617263682D6C697374206C69';
wwv_flow_imp.g_varchar2_table(58) := '7B77696474683A63616C6328313030252F38297D7D2E646D2D5365617263682D726573756C747B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B746578742D6465636F726174696F6E3A6E6F6E653B636F6C6F72';
wwv_flow_imp.g_varchar2_table(59) := '3A696E68657269743B6F75746C696E653A303B626F726465722D7261646975733A3470787D2E646D2D5365617263682D69636F6E7B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B70616464696E673A31367078';
wwv_flow_imp.g_varchar2_table(60) := '3B636F6C6F723A696E68657269743B616C69676E2D6974656D733A63656E7465723B6A7573746966792D636F6E74656E743A63656E7465727D2E646D2D5365617263682D69636F6E202E66617B666F6E742D73697A653A313670787D2E666F7263652D66';
wwv_flow_imp.g_varchar2_table(61) := '612D6C67202E646D2D5365617263682D69636F6E202E66617B666F6E742D73697A653A333270787D2E646D2D5365617263682D696E666F7B70616464696E673A387078203470783B746578742D616C69676E3A63656E7465723B666F6E742D73697A653A';
wwv_flow_imp.g_varchar2_table(62) := '313270787D2E646D2D5365617263682D636C6173737B6F7061636974793A2E36357D2E646D2D5365617263682D726573756C743A666F6375737B626F782D736861646F773A7267626128302C302C302C2E30373529203020347078203870782C696E7365';
wwv_flow_imp.g_varchar2_table(63) := '742023303537326365203020302030203170787D2E646D2D5365617263682D726573756C743A686F7665727B636F6C6F723A236666663B6261636B67726F756E642D636F6C6F723A233035373263653B626F782D736861646F773A7267626128302C302C';
wwv_flow_imp.g_varchar2_table(64) := '302C2E30373529203020347078203870787D2E646D2D5365617263682D726573756C743A666F6375733A686F7665727B626F782D736861646F773A7267626128302C302C302C2E30373529203020347078203870782C696E736574202330353732636520';
wwv_flow_imp.g_varchar2_table(65) := '3020302030203170782C696E7365742023666666203020302030203270787D2E646D2D5365617263682D726573756C743A686F766572202E646D2D5365617263682D696E666F7B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E';
wwv_flow_imp.g_varchar2_table(66) := '3135297D2E646D2D5365617263682D726573756C743A686F766572202E646D2D5365617263682D636C6173737B6F7061636974793A317D2E646D2D5365617263682D726573756C743A6163746976657B626F782D736861646F773A696E73657420726762';
wwv_flow_imp.g_varchar2_table(67) := '6128302C302C302C2E323529203020327078203470787D2E646D2D49636F6E2D6E616D657B6D617267696E2D626F74746F6D3A323470783B666F6E742D7765696768743A3730303B666F6E742D73697A653A343070783B6C696E652D6865696768743A34';
wwv_flow_imp.g_varchar2_table(68) := '3870787D2E646D2D49636F6E7B646973706C61793A666C65783B6D617267696E2D626F74746F6D3A313670787D2E646D2D49636F6E507265766965777B666C65782D67726F773A313B666C65782D62617369733A313030257D2E646D2D49636F6E427569';
wwv_flow_imp.g_varchar2_table(69) := '6C6465727B6D617267696E2D6C6566743A323470783B666C65782D67726F773A303B666C65782D736872696E6B3A303B666C65782D62617369733A33332E33333333257D406D656469612073637265656E20616E6420286D61782D77696474683A373637';
wwv_flow_imp.g_varchar2_table(70) := '7078297B2E646D2D49636F6E7B666C65782D646972656374696F6E3A636F6C756D6E7D2E646D2D49636F6E4275696C6465727B6D617267696E2D746F703A313270783B6D617267696E2D6C6566743A307D7D2E646D2D49636F6E507265766965777B6469';
wwv_flow_imp.g_varchar2_table(71) := '73706C61793A666C65783B70616464696E673A313670783B6D696E2D6865696768743A31323870783B6261636B67726F756E642D636F6C6F723A236666663B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F7376672B78';
wwv_flow_imp.g_varchar2_table(72) := '6D6C3B6261736536342C50484E325A79423462577875637A30696148523063446F764C336433647935334D793576636D63764D6A41774D43397A646D6369494864705A48526F505349794D434967614756705A326830505349794D43492B436A78795A57';
wwv_flow_imp.g_varchar2_table(73) := '4E30494864705A48526F505349794D434967614756705A326830505349794D4349675A6D6C736244306949305A475269492B504339795A574E3050676F38636D566A6443423361575230614430694D5441694947686C6157646F644430694D5441694947';
wwv_flow_imp.g_varchar2_table(74) := '5A706247773949694E474F455934526A6769506A7776636D566A6444344B50484A6C59335167654430694D54416949486B39496A45774969423361575230614430694D5441694947686C6157646F644430694D54416949475A706247773949694E474F45';
wwv_flow_imp.g_varchar2_table(75) := '5934526A6769506A7776636D566A6444344B5043397A646D632B293B6261636B67726F756E642D706F736974696F6E3A3530253B6261636B67726F756E642D73697A653A313670783B626F726465723A31707820736F6C6964207267626128302C302C30';
wwv_flow_imp.g_varchar2_table(76) := '2C2E3135293B626F726465722D7261646975733A3870783B616C69676E2D6974656D733A63656E7465723B6A7573746966792D636F6E74656E743A63656E7465727D2E646D2D546F67676C657B706F736974696F6E3A72656C61746976653B646973706C';
wwv_flow_imp.g_varchar2_table(77) := '61793A626C6F636B3B6D617267696E3A303B77696474683A31303070783B6865696768743A343870783B6261636B67726F756E642D636F6C6F723A236666663B6F75746C696E653A303B626F726465722D7261646975733A3470783B626F782D73686164';
wwv_flow_imp.g_varchar2_table(78) := '6F773A696E736574207267626128302C302C302C2E313529203020302030203170783B637572736F723A706F696E7465723B7472616E736974696F6E3A2E317320656173653B2D7765626B69742D617070656172616E63653A6E6F6E653B2D6D6F7A2D61';
wwv_flow_imp.g_varchar2_table(79) := '7070656172616E63653A6E6F6E653B617070656172616E63653A6E6F6E657D2E646D2D546F67676C653A61667465727B706F736974696F6E3A6162736F6C7574653B746F703A3470783B6C6566743A3470783B77696474683A343870783B686569676874';
wwv_flow_imp.g_varchar2_table(80) := '3A343070783B636F6E74656E743A22536D616C6C223B746578742D616C69676E3A63656E7465723B666F6E742D7765696768743A3730303B666F6E742D73697A653A313170783B6C696E652D6865696768743A343070783B636F6C6F723A726762612830';
wwv_flow_imp.g_varchar2_table(81) := '2C302C302C2E3635293B6261636B67726F756E643A3020303B6261636B67726F756E642D636F6C6F723A236630663066303B626F726465722D7261646975733A3270783B626F782D736861646F773A696E736574207267626128302C302C302C2E313529';
wwv_flow_imp.g_varchar2_table(82) := '203020302030203170783B7472616E736974696F6E3A2E317320656173657D2E646D2D546F67676C653A636865636B65647B6261636B67726F756E642D636F6C6F723A233035373263657D2E646D2D546F67676C653A636865636B65643A61667465727B';
wwv_flow_imp.g_varchar2_table(83) := '6C6566743A343870783B636F6E74656E743A274C61726765273B636F6C6F723A233035373263653B6261636B67726F756E642D636F6C6F723A236666663B626F782D736861646F773A7267626128302C302C302C2E313529203020302030203170787D2E';
wwv_flow_imp.g_varchar2_table(84) := '646D2D526164696F50696C6C5365747B646973706C61793A666C65783B77696474683A313030253B6261636B67726F756E642D636F6C6F723A236666663B626F726465722D7261646975733A3470783B626F782D736861646F773A696E73657420302030';
wwv_flow_imp.g_varchar2_table(85) := '203020317078207267626128302C302C302C2E3135297D2E646D2D526164696F50696C6C5365742D6F7074696F6E7B666C65782D67726F773A313B666C65782D736872696E6B3A303B666C65782D62617369733A6175746F7D2E646D2D526164696F5069';
wwv_flow_imp.g_varchar2_table(86) := '6C6C5365742D6F7074696F6E3A6E6F74283A66697273742D6368696C64297B626F726465722D6C6566743A31707820736F6C6964207267626128302C302C302C2E3135297D2E646D2D526164696F50696C6C5365742D6F7074696F6E3A66697273742D63';
wwv_flow_imp.g_varchar2_table(87) := '68696C6420696E7075742B6C6162656C7B626F726465722D746F702D6C6566742D7261646975733A3470783B626F726465722D626F74746F6D2D6C6566742D7261646975733A3470787D2E646D2D526164696F50696C6C5365742D6F7074696F6E3A6C61';
wwv_flow_imp.g_varchar2_table(88) := '73742D6368696C6420696E7075742B6C6162656C7B626F726465722D746F702D72696768742D7261646975733A3470783B626F726465722D626F74746F6D2D72696768742D7261646975733A3470787D2E646D2D526164696F50696C6C5365742D6F7074';
wwv_flow_imp.g_varchar2_table(89) := '696F6E20696E7075747B706F736974696F6E3A6162736F6C7574653B6F766572666C6F773A68696464656E3B636C69703A726563742830203020302030293B6D617267696E3A2D3170783B70616464696E673A303B77696474683A3170783B6865696768';
wwv_flow_imp.g_varchar2_table(90) := '743A3170783B626F726465723A307D2E646D2D526164696F50696C6C5365742D6F7074696F6E20696E7075742B6C6162656C7B646973706C61793A626C6F636B3B70616464696E673A38707820313270783B746578742D616C69676E3A63656E7465723B';
wwv_flow_imp.g_varchar2_table(91) := '666F6E742D73697A653A313270783B6C696E652D6865696768743A313670783B636F6C6F723A233338333833383B637572736F723A706F696E7465727D2E646D2D526164696F50696C6C5365742D6F7074696F6E20696E7075743A636865636B65642B6C';
wwv_flow_imp.g_varchar2_table(92) := '6162656C7B666F6E742D7765696768743A3730303B636F6C6F723A236639663966393B6261636B67726F756E642D636F6C6F723A233035373263657D2E646D2D526164696F50696C6C5365742D6F7074696F6E20696E7075743A666F6375732B6C616265';
wwv_flow_imp.g_varchar2_table(93) := '6C7B626F782D736861646F773A696E7365742023303537326365203020302030203170782C696E7365742023666666203020302030203270787D2E646D2D526164696F50696C6C5365742D2D6C61726765202E646D2D526164696F50696C6C5365742D6F';
wwv_flow_imp.g_varchar2_table(94) := '7074696F6E20696E7075742B6C6162656C7B70616464696E673A35707820323470783B666F6E742D73697A653A313470783B6C696E652D6865696768743A333270787D2E646D2D526164696F5365747B646973706C61793A666C65783B666C65782D7772';
wwv_flow_imp.g_varchar2_table(95) := '61703A777261707D2E646D2D526164696F5365742D6F7074696F6E20696E7075747B706F736974696F6E3A6162736F6C7574653B6F766572666C6F773A68696464656E3B636C69703A726563742830203020302030293B6D617267696E3A2D3170783B70';
wwv_flow_imp.g_varchar2_table(96) := '616464696E673A303B77696474683A3170783B6865696768743A3170783B626F726465723A307D2E646D2D526164696F5365742D6F7074696F6E20696E7075742B6C6162656C7B646973706C61793A666C65783B666C65782D646972656374696F6E3A63';
wwv_flow_imp.g_varchar2_table(97) := '6F6C756D6E3B70616464696E673A3870783B77696474683A383070783B6865696768743A383070783B746578742D616C69676E3A63656E7465723B626F726465722D7261646975733A3470783B637572736F723A706F696E7465723B616C69676E2D6974';
wwv_flow_imp.g_varchar2_table(98) := '656D733A63656E7465727D2E646D2D526164696F5365742D69636F6E7B6D617267696E3A3870783B2D6D732D677269642D726F772D616C69676E3A63656E7465723B616C69676E2D73656C663A63656E7465727D2E646D2D526164696F5365742D6C6162';
wwv_flow_imp.g_varchar2_table(99) := '656C7B646973706C61793A626C6F636B3B666F6E742D73697A653A313270783B6C696E652D6865696768743A313670783B2D6D732D677269642D726F772D616C69676E3A63656E7465723B616C69676E2D73656C663A63656E7465727D2E646D2D526164';
wwv_flow_imp.g_varchar2_table(100) := '696F5365742D6F7074696F6E20696E7075743A636865636B65642B6C6162656C7B6261636B67726F756E642D636F6C6F723A236666663B626F782D736861646F773A696E7365742023303537326365203020302030203170787D2E646D2D4669656C647B';
wwv_flow_imp.g_varchar2_table(101) := '646973706C61793A666C65783B6D617267696E2D626F74746F6D3A313270787D2E646D2D4669656C643A6C6173742D6368696C647B6D617267696E2D626F74746F6D3A307D2E646D2D4669656C644C6162656C7B646973706C61793A626C6F636B3B6D61';
wwv_flow_imp.g_varchar2_table(102) := '7267696E2D72696768743A313270783B77696474683A31303070783B746578742D616C69676E3A72696768743B666F6E742D73697A653A313370783B636F6C6F723A7267626128302C302C302C2E3635293B666C65782D736872696E6B3A303B2D6D732D';
wwv_flow_imp.g_varchar2_table(103) := '677269642D726F772D616C69676E3A63656E7465723B616C69676E2D73656C663A63656E7465727D406D656469612073637265656E20616E6420286D61782D77696474683A3437397078297B2E646D2D4669656C647B666C65782D646972656374696F6E';
wwv_flow_imp.g_varchar2_table(104) := '3A636F6C756D6E7D2E646D2D4669656C643A6C6173742D6368696C647B6D617267696E2D626F74746F6D3A307D2E646D2D4669656C644C6162656C7B6D617267696E2D72696768743A303B6D617267696E2D626F74746F6D3A3470783B77696474683A31';
wwv_flow_imp.g_varchar2_table(105) := '3030253B746578742D616C69676E3A6C6566747D7D2E646D2D4669656C642073656C6563747B646973706C61793A626C6F636B3B6D617267696E3A303B70616464696E673A387078203332707820387078203870783B77696474683A313030253B666F6E';
wwv_flow_imp.g_varchar2_table(106) := '742D73697A653A313470783B6C696E652D6865696768743A313B6261636B67726F756E642D636F6C6F723A236666663B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F7376672B786D6C3B6261736536342C50484E325A';
wwv_flow_imp.g_varchar2_table(107) := '79423462577875637A30696148523063446F764C336433647935334D793576636D63764D6A41774D43397A646D6369494864705A48526F505349304D4441694947686C6157646F644430694D6A41774969423261575633516D3934505349744F546B754E';
wwv_flow_imp.g_varchar2_table(108) := '5341774C6A55674E444177494449774D4349675A573568596D786C4C574A685932746E636D3931626D5139496D356C647941744F546B754E5341774C6A55674E444177494449774D43492B50484268644767675A6D6C7362443069497A51304E4349675A';
wwv_flow_imp.g_varchar2_table(109) := '443069545445314E6934794E5341334D793433597A41674D5334324C5334324D5449674D7934794C5445754F444931494451754E444931624330314E4334304D6A55674E5451754E4449314C5455304C6A51794E5330314E4334304D6A566A4C5449754E';
wwv_flow_imp.g_varchar2_table(110) := '444D344C5449754E444D344C5449754E444D344C5459754E4341774C5467754F444D33637A59754E4330794C6A517A4F4341344C6A677A4E794177624451314C6A55344F4341304E5334314E7A51674E4455754E5463314C5451314C6A55334E574D794C';
wwv_flow_imp.g_varchar2_table(111) := '6A517A4F4330794C6A517A4F4341324C6A4D354F5330794C6A517A4F4341344C6A677A4E794177494445754D6A4932494445754D6A4932494445754F444D34494449754F444931494445754F444D34494451754E44457A65694976506A777663335A6E50';
wwv_flow_imp.g_varchar2_table(112) := '673D3D293B6261636B67726F756E642D706F736974696F6E3A31303025203530253B6261636B67726F756E642D73697A653A3332707820313670783B6261636B67726F756E642D7265706561743A6E6F2D7265706561743B6F75746C696E653A303B626F';
wwv_flow_imp.g_varchar2_table(113) := '726465723A31707820736F6C6964207267626128302C302C302C2E32293B626F726465722D7261646975733A3470783B2D7765626B69742D617070656172616E63653A6E6F6E653B2D6D6F7A2D617070656172616E63653A6E6F6E653B61707065617261';
wwv_flow_imp.g_varchar2_table(114) := '6E63653A6E6F6E657D2E646D2D4669656C642073656C6563743A3A2D6D732D657870616E647B646973706C61793A6E6F6E657D2E646D2D4669656C642073656C6563743A666F6375737B626F726465722D636F6C6F723A233035373263657D2E646D2D49';
wwv_flow_imp.g_varchar2_table(115) := '636F6E4F75747075747B646973706C61793A666C65783B666C65782D777261703A6E6F777261703B616C69676E2D6974656D733A666C65782D73746172747D2E646D2D49636F6E4F75747075743E2E646D2D49636F6E4F75747075742D636F6C2068327B';
wwv_flow_imp.g_varchar2_table(116) := '646973706C61793A626C6F636B3B666F6E742D73697A653A313270783B666C65782D67726F773A313B666C65782D736872696E6B3A313B666C65782D62617369733A6175746F3B616C69676E2D73656C663A666C65782D73746172743B6D617267696E3A';
wwv_flow_imp.g_varchar2_table(117) := '303B666F6E742D7765696768743A3430307D2E646D2D49636F6E4F75747075743E2E646D2D49636F6E4F75747075742D636F6C2D2D68746D6C7B666C65782D67726F773A313B666C65782D736872696E6B3A313B666C65782D62617369733A6175746F7D';
wwv_flow_imp.g_varchar2_table(118) := '2E646D2D49636F6E4F75747075743E2E646D2D49636F6E4F75747075742D636F6C2D2D646F776E6C6F61647B616C69676E2D73656C663A666C65782D73746172743B746578742D616C69676E3A63656E7465723B6D617267696E2D746F703A313870783B';
wwv_flow_imp.g_varchar2_table(119) := '666C65782D67726F773A307D2E646D2D49636F6E4F75747075743E2E646D2D49636F6E4F75747075742D636F6C3A6E6F74283A66697273742D6368696C64297B6D617267696E2D6C6566743A313670787D2E646D2D436F64657B646973706C61793A626C';
wwv_flow_imp.g_varchar2_table(120) := '6F636B3B70616464696E673A38707820313270783B6D61782D77696474683A313030253B666F6E742D73697A653A313270783B666F6E742D66616D696C793A6D6F6E6F73706163653B6C696E652D6865696768743A313670783B636F6C6F723A72676261';
wwv_flow_imp.g_varchar2_table(121) := '283235352C3235352C3235352C2E3735293B6261636B67726F756E642D636F6C6F723A233331333733633B626F726465722D7261646975733A3470783B637572736F723A746578743B2D7765626B69742D757365722D73656C6563743A616C6C3B2D6D6F';
wwv_flow_imp.g_varchar2_table(122) := '7A2D757365722D73656C6563743A616C6C3B2D6D732D757365722D73656C6563743A616C6C3B757365722D73656C6563743A616C6C7D406D656469612073637265656E20616E6420286D61782D77696474683A3736377078297B2E646D2D49636F6E4F75';
wwv_flow_imp.g_varchar2_table(123) := '747075747B666C65782D646972656374696F6E3A636F6C756D6E3B6D617267696E2D746F703A333270787D2E646D2D49636F6E4F75747075743E2E646D2D49636F6E4F75747075742D636F6C7B77696474683A313030253B2D6D732D677269642D726F77';
wwv_flow_imp.g_varchar2_table(124) := '2D616C69676E3A6175746F3B616C69676E2D73656C663A6175746F7D2E646D2D49636F6E4F75747075743E2E646D2D49636F6E4F75747075742D636F6C3A6E6F74283A66697273742D6368696C64297B6D617267696E2D746F703A313670783B6D617267';
wwv_flow_imp.g_varchar2_table(125) := '696E2D6C6566743A307D2E646D2D436F64657B77696474683A313030257D7D2E646D2D446573637B666F6E742D73697A653A313270783B636F6C6F723A7267626128302C302C302C2E35297D2E646D2D4578616D706C65737B6D617267696E2D746F703A';
wwv_flow_imp.g_varchar2_table(126) := '343870787D2E646D2D4578616D706C65732068327B6D617267696E3A30203020313270783B666F6E742D7765696768743A3530303B666F6E742D73697A653A323470787D2E646D2D50726576696577737B646973706C61793A666C65783B6D617267696E';
wwv_flow_imp.g_varchar2_table(127) := '2D72696768743A2D3870783B6D617267696E2D6C6566743A2D3870783B666C65782D777261703A777261707D406D656469612073637265656E20616E6420286D61782D77696474683A3736377078297B2E646D2D5072657669657773202E646D2D507265';
wwv_flow_imp.g_varchar2_table(128) := '766965777B77696474683A313030257D7D2E646D2D507265766965777B646973706C61793A666C65783B6F766572666C6F773A68696464656E3B6D617267696E2D72696768743A3870783B6D617267696E2D626F74746F6D3A313670783B6D617267696E';
wwv_flow_imp.g_varchar2_table(129) := '2D6C6566743A3870783B70616464696E673A313670783B77696474683A63616C6328353025202D2031367078293B6261636B67726F756E642D636F6C6F723A236664666466643B626F726465723A31707820736F6C6964207267626128302C302C302C2E';
wwv_flow_imp.g_varchar2_table(130) := '3135293B626F726465722D7261646975733A3470783B637572736F723A64656661756C743B2D7765626B69742D757365722D73656C6563743A6E6F6E653B2D6D6F7A2D757365722D73656C6563743A6E6F6E653B2D6D732D757365722D73656C6563743A';
wwv_flow_imp.g_varchar2_table(131) := '6E6F6E653B757365722D73656C6563743A6E6F6E657D2E646D2D507265766965772D2D6E6F5061647B70616464696E673A307D2E612D4947202E69672D7370616E2D69636F6E2D7069636B65727B70616464696E673A3370783B706F736974696F6E3A73';
wwv_flow_imp.g_varchar2_table(132) := '746174696321696D706F7274616E743B6D617267696E2D696E6C696E652D73746172743A3021696D706F7274616E747D2E612D4947202E69672D627574746F6E2D69636F6E2D7069636B65727B70616464696E673A30203470787D2E69672D6469762D69';
wwv_flow_imp.g_varchar2_table(133) := '636F6E2D7069636B65727B706F736974696F6E3A72656C61746976653B77696474683A313030257D2E69672D6469762D69636F6E2D7069636B6572202E69672D627574746F6E2D69636F6E2D7069636B65723A6E6F74282E69702D69636F6E2D6F6E6C79';
wwv_flow_imp.g_varchar2_table(134) := '297B706F736974696F6E3A6162736F6C7574653B746F703A2D3370783B72696768743A3170783B6D696E2D77696474683A343070787D2E612D47562D636F6C756D6E4974656D202E69672D6469762D69636F6E2D7069636B6572202E69672D627574746F';
wwv_flow_imp.g_varchar2_table(135) := '6E2D69636F6E2D7069636B65723A6E6F74282E69702D69636F6E2D6F6E6C79297B706F736974696F6E3A6162736F6C7574653B6865696768743A313030253B746F703A303B72696768743A3170783B6D617267696E3A303B6D696E2D77696474683A3430';
wwv_flow_imp.g_varchar2_table(136) := '70787D2E69672D6469762D69636F6E2D7069636B6572202E69702D69636F6E2D6F6E6C797B706F736974696F6E3A72656C61746976653B6865696768743A313030257D2E69672D6469762D69636F6E2D7069636B6572202E742D427574746F6E2D2D6963';
wwv_flow_imp.g_varchar2_table(137) := '6F6E2E69702D69636F6E2D6F6E6C797B6C696E652D6865696768743A312E3672656D3B746578742D616C69676E3A63656E7465723B6D696E2D77696474683A3472656D7D2E69672D6469762D69636F6E2D7069636B6572202E617065782D6974656D2D69';
wwv_flow_imp.g_varchar2_table(138) := '636F6E7B666C6F61743A6E6F6E657D2E696769636F6E7069636B65727B6865696768743A3130302521696D706F7274616E747D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(132675857843228150)
,p_plugin_id=>wwv_flow_imp.id(208808430900605280)
,p_file_name=>'css/IPui.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
