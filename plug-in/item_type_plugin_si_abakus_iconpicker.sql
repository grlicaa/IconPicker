prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.04.04'
,p_release=>'18.1.0.00.45'
,p_default_workspace_id=>1612471744036644
,p_default_application_id=>101
,p_default_owner=>'SIOUG'
);
end;
/
prompt --application/shared_components/plugins/item_type/si_abakus_iconpicker
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(18526883808784064)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'SI.ABAKUS.ICONPICKER'
,p_display_name=>'IconPicker'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#IPicons.js',
'#PLUGIN_FILES#IPdoc.js',
'#PLUGIN_FILES#IPgrid.js',
''))
,p_css_file_urls=>'#PLUGIN_FILES#IPui.css'
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
,p_version_identifier=>'1.2'
,p_about_url=>'https://github.com/grlicaa/IconPicker'
,p_files_version=>8
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18529018469794724)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Dialog button hover title'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Open list of Icons'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'On hover Icon Picker link, display title "Open list of Icons". (This is for easy translation to other languages.)'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18529703838797355)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Dialog cancel button text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Cancel'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'On dialog windows, "Cancel" button title. (This is for easy translation to other languages.)'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18530205359799895)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Dialog search field placeholder'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Search icons...'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'Used for placeholder on popUP dialog page...'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18530782579803803)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'SMALL icons label'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Small'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'For smaller icons Button label'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18531272335806392)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'LARGE icons label'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Large'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'For larger icons Button label'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18531789179808765)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4372382503125680)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18532234779811313)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Dialog title'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Icon Picker'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_help_text=>'Dialog title, default value "Icon Picker"'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18532713985814629)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18533248654817639)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18533721962819491)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18534229724821964)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18534767576828476)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(18535243677830560)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
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
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C206661202A2F0A0A76617220666F6E7461706578203D20666F6E7461706578207C7C207B7D3B0A0A2F2F666F726561636820417272617920666F72206E6F64654C69737420696E2049450A69662028214E6F64654C6973742E7072';
wwv_flow_api.g_varchar2_table(2) := '6F746F747970652E666F724561636829207B0A20204E6F64654C6973742E70726F746F747970652E666F7245616368203D2041727261792E70726F746F747970652E666F72456163683B0A7D0A0A66756E6374696F6E20736574456C656D656E7449636F';
wwv_flow_api.g_varchar2_table(3) := '6E28705F6E616D652C20705F76616C29207B0A09242822696E70757423222B705F6E616D652B222E617065782D6974656D2D6861732D69636F6E22292E706172656E74282264697622292E66696E6428227370616E2E617065782D6974656D2D69636F6E';
wwv_flow_api.g_varchar2_table(4) := '22292E617474722822636C617373222C22617065782D6974656D2D69636F6E20666120222B705F76616C293B0A7D0A66756E6374696F6E20736574456C656D656E7456616C756528705F6E616D652C20705F76616C29207B0A09242822696E7075742322';
wwv_flow_api.g_varchar2_table(5) := '2B705F6E616D65292E76616C28705F76616C293B0A09736574456C656D656E7449636F6E28705F6E616D652C20705F76616C293B0A7D0A66756E6374696F6E207365744947456C656D656E7456616C756528705F726567696F6E49642C20705F726F7749';
wwv_flow_api.g_varchar2_table(6) := '642C20705F636F6C756D6E2C20705F76616C29207B0A09636F6E7374207769646765742020202020203D20617065782E726567696F6E28705F726567696F6E4964292E77696467657428293B0A09636F6E7374206772696420202020202020203D207769';
wwv_flow_api.g_varchar2_table(7) := '646765742E696E7465726163746976654772696428276765745669657773272C276772696427293B20200A09636F6E7374206D6F64656C202020202020203D20677269642E6D6F64656C3B200A20202020636F6E7374206669656C6473203D2077696467';
wwv_flow_api.g_varchar2_table(8) := '65742E696E746572616374697665477269642827676574566965777327292E677269642E6D6F64656C2E6765744F7074696F6E28276669656C647327293B0A090A202020206C6574206669656C64203D2027273B0A09666F72202876617220656C20696E';
wwv_flow_api.g_varchar2_table(9) := '206669656C647329207B0A0909696620286669656C64735B656C5D2E656C656D656E744964203D3D3D20705F636F6C756D6E29207B0A0909096669656C64203D20656C3B0A09097D0A097D0A202020206D6F64656C2E7365745265636F726456616C7565';
wwv_flow_api.g_varchar2_table(10) := '28705F726F7749642C206669656C642C20705F76616C293B0A7D0A66756E6374696F6E20636C6F73654469616C6F6749502869735F677269642C20705F6469616C6F672C20705F726567696F6E49642C20705F726F7749642C20705F636F6C756D6E2C20';
wwv_flow_api.g_varchar2_table(11) := '705F76616C29207B0A096966202869735F6772696429207B0A09092428222349636F6E5069636B65724469616C6F67426F7822292E6469616C6F672822636C6F736522293B0A09097365744947456C656D656E7456616C756528705F726567696F6E4964';
wwv_flow_api.g_varchar2_table(12) := '2C20705F726F7749642C20705F636F6C756D6E2C20705F76616C290A09090A097D0A09656C7365207B0A0909736574456C656D656E7456616C756528705F6469616C6F672C20705F76616C293B0A09092428222349636F6E5069636B65724469616C6F67';
wwv_flow_api.g_varchar2_table(13) := '426F7822292E6469616C6F672822636C6F736522293B0A097D0A7D0A0A66756E6374696F6E206164644974656D4C69737428704974656D4C69737429207B0A092428704974656D4C697374292E656163682866756E6374696F6E202829207B200A090924';
wwv_flow_api.g_varchar2_table(14) := '2874686973292E69636F6E4C697374287B0A0909096D756C7469706C653A2066616C73652C0A0909096E617669676174696F6E3A20747275652C0A0909096974656D53656C6563746F723A2066616C73650A09097D293B090A097D293B09090A7D0A0A66';
wwv_flow_api.g_varchar2_table(15) := '756E6374696F6E206C6F616449636F6E5069636B65724469616C6F67287044436C6F7365422C207055736549636F6E4C69737429207B0A09242822626F647922292E617070656E6428273C6469762069643D2249636F6E5069636B65724469616C6F6742';
wwv_flow_api.g_varchar2_table(16) := '6F78223E3C2F6469763E27293B0A09092F2A207475726E2064697620696E746F206469616C6F67202A2F0A092428272349636F6E5069636B65724469616C6F67426F7827292E6469616C6F67280A202020202020202020202020202020207B6D6F64616C';
wwv_flow_api.g_varchar2_table(17) := '203A20747275650A202020202020202020202020202020202C7469746C65203A202249636F6E205069636B6572220A202020202020202020202020202020202C6175746F4F70656E3A66616C73650A202020202020202020202020202020202C72657369';
wwv_flow_api.g_varchar2_table(18) := '7A61626C653A747275650A202020202020202020202020202020202C77696474683A203630300A202020202020202020202020202020202C6865696768743A203830300A202020202020202020202020202020202C636C6F73654F6E457363617065203A';
wwv_flow_api.g_varchar2_table(19) := '20747275650A202020202020202020202020202020202C7469726767456C656D203A2022220A202020202020202020202020202020202C74697267674974656D203A207B7D0A090909092C73686F7749636F6E4C6162656C3A20747275650A2020202020';
wwv_flow_api.g_varchar2_table(20) := '20202020202020202020202C6D6F64616C4974656D203A2066616C73650A090909092C75736549636F6E4C6973743A207055736549636F6E4C6973740A202020202020202020202020202020202C6F70656E3A2066756E6374696F6E202829207B0A0909';
wwv_flow_api.g_varchar2_table(21) := '09090977696E646F772E6164644576656E744C697374656E657228226B6579646F776E222C2066756E6374696F6E286576656E7429207B0A090909090909092F2F206172726F77206B65790A09090909090909696620285B33372C2033382C2033392C20';
wwv_flow_api.g_varchar2_table(22) := '34305D2E696E6465784F66286576656E742E6B6579436F646529203E202D3129207B0A09090909090909096576656E742E70726576656E7444656661756C7428293B0A090909090909097D0A0909090909097D293B09090909090A202020202020202020';
wwv_flow_api.g_varchar2_table(23) := '2020202020202020202020696E697449636F6E732820666F6E74617065782C200A09090909092020202020202020202020242874686973292E6469616C6F6728226F7074696F6E222C20227469726767456C656D22292C200A0909090909090920202024';
wwv_flow_api.g_varchar2_table(24) := '2874686973292E6469616C6F6728226F7074696F6E222C202274697267674974656D22292C20200A090909090909092020207B0969735F677269643A242874686973292E6469616C6F6728226F7074696F6E222C20226D6F64616C4974656D22292C200A';
wwv_flow_api.g_varchar2_table(25) := '09090909092020202020202020202020202020202073686F7749636F6E4C6162656C3A242874686973292E6469616C6F6728226F7074696F6E222C202273686F7749636F6E4C6162656C22292C0A09090909090909090975736549636F6E4C6973743A24';
wwv_flow_api.g_varchar2_table(26) := '2874686973292E6469616C6F6728226F7074696F6E222C202275736549636F6E4C69737422290A090909090909092020207D0A09090909090909293B0A202020202020202020202020202020207D0A202020202020202020202020202020202C636C6F73';
wwv_flow_api.g_varchar2_table(27) := '653A2066756E6374696F6E202829207B0A20202020202020202020202020202020202020202428226D61696E2E646D2D426F647922292E72656D6F766528293B0A202020202020202020202020202020207D0A202020202020202020202020202020202C';
wwv_flow_api.g_varchar2_table(28) := '63616E63656C3A2066756E6374696F6E202829207B0A20202020202020202020202020202020202020202428226D61696E2E646D2D426F647922292E72656D6F766528293B0A202020202020202020202020202020207D2020202020202020202020200A';
wwv_flow_api.g_varchar2_table(29) := '202020202020202020202020202020202C627574746F6E73203A5B0A09090909097B20097465787420203A7044436C6F7365422C0A090909090909636C69636B203A2066756E6374696F6E202829207B0A09090909090909242874686973292E6469616C';
wwv_flow_api.g_varchar2_table(30) := '6F672822636C6F736522293B0A0909090909097D0A09090909097D0A202020202020202020202020202020205D0A2020202020202020202020207D293B0A7D0A0A666F6E74617065782E24203D2066756E6374696F6E282073656C6563746F7220297B0A';
wwv_flow_api.g_varchar2_table(31) := '202020207661722053656C203D2066756E6374696F6E20282073656C6563746F722029207B0A20202020202020207661722073656C6563746564203D205B5D3B0A0A20202020202020206966202820747970656F662073656C6563746F72203D3D3D2027';
wwv_flow_api.g_varchar2_table(32) := '737472696E67272029207B0A20202020202020202020202073656C6563746564203D20646F63756D656E742E717565727953656C6563746F72416C6C282073656C6563746F7220293B0A20202020202020207D20656C7365207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(33) := '20202073656C65637465642E70757368282073656C6563746F7220293B0A20202020202020207D0A0A2020202020202020746869732E656C656D656E7473203D2073656C65637465643B0A2020202020202020746869732E6C656E677468203D20746869';
wwv_flow_api.g_varchar2_table(34) := '732E656C656D656E74732E6C656E6774683B0A0A202020202020202072657475726E20746869733B0A202020207D3B0A0A2020202053656C2E70726F746F74797065203D207B0A0A2020202020202020616464436C6173733A2066756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(35) := '20636C2029207B0A20202020202020202020202020202020202020202F2F2072656D6F7665206D756C7469706C65207370616365730A202020202020202020202020202020202020202076617220737472203D20636C2E7265706C616365282F202B283F';
wwv_flow_api.g_varchar2_table(36) := '3D20292F672C2727292C0A202020202020202020202020202020202020202020202020636C6173734172726179203D207374722E73706C6974282027202720293B0A0A2020202020202020202020202020202020202020746869732E656C656D656E7473';
wwv_flow_api.g_varchar2_table(37) := '2E666F7245616368282066756E6374696F6E202820656C656D2029207B0A202020202020202020202020202020202020202020202020636C61737341727261792E666F7245616368282066756E6374696F6E202820632029207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(38) := '202020202020202020202020202020202020206966202820632029207B0A2020202020202020202020202020202020202020202020202020202020202020656C656D2E636C6173734C6973742E61646428206320293B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(39) := '2020202020202020202020202020207D0A2020202020202020202020202020202020202020202020207D290A0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020202020202072657475726E2074686973';
wwv_flow_api.g_varchar2_table(40) := '3B0A20202020202020207D2C0A0A202020202020202072656D6F7665436C6173733A2066756E6374696F6E202820636C2029207B0A0A2020202020202020202020202020202020202020202020207661722072656D6F7665416C6C436C6173736573203D';
wwv_flow_api.g_varchar2_table(41) := '2066756E6374696F6E202820656C2029207B0A20202020202020202020202020202020202020202020202020202020656C2E636C6173734E616D65203D2027273B0A2020202020202020202020202020202020202020202020207D3B0A0A202020202020';
wwv_flow_api.g_varchar2_table(42) := '2020202020202020202020202020202020207661722072656D6F76654F6E65436C617373203D2066756E6374696F6E202820656C2029207B0A20202020202020202020202020202020202020202020202020202020656C2E636C6173734C6973742E7265';
wwv_flow_api.g_varchar2_table(43) := '6D6F76652820636C20293B0A2020202020202020202020202020202020202020202020207D3B0A0A20202020202020202020202020202020202020202020202076617220616374696F6E203D20636C203F2072656D6F76654F6E65436C617373203A2072';
wwv_flow_api.g_varchar2_table(44) := '656D6F7665416C6C436C61737365733B0A0A202020202020202020202020202020202020202020202020746869732E656C656D656E74732E666F7245616368282066756E6374696F6E202820656C656D2029207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(45) := '20202020202020202020202020616374696F6E2820656C656D20293B0A2020202020202020202020202020202020202020202020207D293B0A0A20202020202020202020202020202020202020202020202072657475726E20746869733B0A2020202020';
wwv_flow_api.g_varchar2_table(46) := '2020207D2C0A0A2020202020202020676574436C6173733A2066756E6374696F6E202829207B0A202020202020202020202020202020202020202072657475726E20746869732E656C656D656E74735B305D2E636C6173734C6973742E76616C75653B0A';
wwv_flow_api.g_varchar2_table(47) := '20202020202020207D2C0A0A20202020202020206F6E3A2066756E6374696F6E2028206576656E744E616D652C2066756E632029207B0A20202020202020202020202020202020746869732E656C656D656E74732E666F7245616368282066756E637469';
wwv_flow_api.g_varchar2_table(48) := '6F6E2820656C656D20297B0A2020202020202020202020202020202020202020656C656D2E6164644576656E744C697374656E657228206576656E744E616D652C2066756E6320293B0A202020202020202020202020202020207D293B0A0A2020202020';
wwv_flow_api.g_varchar2_table(49) := '202020202020202020202072657475726E20746869733B0A20202020202020207D2C0A0A202020202020202076616C3A2066756E6374696F6E202829207B0A202020202020202020202020202020207661722076616C203D2027273B0A20202020202020';
wwv_flow_api.g_varchar2_table(50) := '202020202020202020746869732E656C656D656E74732E666F7245616368282066756E6374696F6E202820656C656D2029207B0A2020202020202020202020202020202020202020737769746368202820656C656D2E6E6F64654E616D652029207B0A20';
wwv_flow_api.g_varchar2_table(51) := '2020202020202020202020202020202020202020202020636173652027494E505554273A0A202020202020202020202020202020202020202020202020202020206966202820656C656D2E636865636B65642029207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '2020202020202020202020202020202020202076616C203D20656C656D2E76616C75653B0A202020202020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020202020202020202020627265616B';
wwv_flow_api.g_varchar2_table(53) := '3B0A0A20202020202020202020202020202020202020202020202063617365202753454C454354273A0A2020202020202020202020202020202020202020202020202020202076616C203D20656C656D2E6F7074696F6E735B20656C656D2E73656C6563';
wwv_flow_api.g_varchar2_table(54) := '746564496E646578205D2E76616C75653B0A20202020202020202020202020202020202020202020202020202020627265616B3B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A0A20202020';
wwv_flow_api.g_varchar2_table(55) := '20202020202020202020202072657475726E2076616C3B0A20202020202020207D2C0A0A2020202020202020746578743A2066756E6374696F6E202820742029207B0A202020202020202020202020202020206966202820742029207B0A202020202020';
wwv_flow_api.g_varchar2_table(56) := '2020202020202020202020202020746869732E656C656D656E74732E666F7245616368282066756E6374696F6E202820656C656D2029207B0A202020202020202020202020202020202020202020202020656C656D2E74657874436F6E74656E74203D20';
wwv_flow_api.g_varchar2_table(57) := '743B0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202072657475726E20746869733B0A20202020202020207D2C0A0A202020202020202068746D6C3A';
wwv_flow_api.g_varchar2_table(58) := '2066756E6374696F6E202820682029207B0A202020202020202020202020202020207661722068746D6C3B0A0A202020202020202020202020202020206966202820747970656F662068203D3D3D2027737472696E672729207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(59) := '2020202020202020202020746869732E656C656D656E74732E666F7245616368282066756E6374696F6E202820656C656D2029207B0A202020202020202020202020202020202020202020202020656C656D2E696E6E657248544D4C203D20683B0A2020';
wwv_flow_api.g_varchar2_table(60) := '2020202020202020202020202020202020207D293B0A202020202020202020202020202020202020202072657475726E20746869733B0A202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(61) := '746869732E656C656D656E74732E666F7245616368282066756E6374696F6E202820656C656D2029207B0A20202020202020202020202020202020202020202020202068746D6C203D20656C656D2E696E6E657248544D4C3B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(62) := '202020202020202020207D293B0A202020202020202020202020202020202020202072657475726E2068746D6C3B0A202020202020202020202020202020207D0A20202020202020207D2C0A0A2020202020202020706172656E743A2066756E6374696F';
wwv_flow_api.g_varchar2_table(63) := '6E202829207B0A202020202020202020202020202020202020202076617220703B0A2020202020202020202020202020202020202020746869732E656C656D656E74732E666F7245616368282066756E6374696F6E202820656C656D2029207B0A202020';
wwv_flow_api.g_varchar2_table(64) := '20202020202020202020202020202020202020202070203D206E65772053656C2820656C656D2E706172656E744E6F646520293B0A20202020202020202020202020202020202020207D293B0A0A20202020202020202020202020202020202020207265';
wwv_flow_api.g_varchar2_table(65) := '7475726E20703B0A20202020202020207D2C0A0A2020202020202020686964653A2066756E6374696F6E202829207B0A20202020202020202020202020202020746869732E656C656D656E74732E666F7245616368282066756E6374696F6E202820656C';
wwv_flow_api.g_varchar2_table(66) := '656D2029207B0A2020202020202020202020202020202020202020656C656D2E7374796C652E646973706C6179203D20276E6F6E65273B0A202020202020202020202020202020207D293B0A0A2020202020202020202020202020202072657475726E20';
wwv_flow_api.g_varchar2_table(67) := '746869733B0A20202020202020207D2C0A0A202020202020202073686F773A2066756E6374696F6E202820742029207B0A20202020202020202020202020202020746869732E656C656D656E74732E666F7245616368282066756E6374696F6E20282065';
wwv_flow_api.g_varchar2_table(68) := '6C656D2029207B0A2020202020202020202020202020202020202020656C656D2E7374796C652E646973706C6179203D206E756C6C3B0A202020202020202020202020202020207D293B0A0A2020202020202020202020202020202072657475726E2074';
wwv_flow_api.g_varchar2_table(69) := '6869733B0A20202020202020207D0A0A202020207D3B0A0A2020202072657475726E206E65772053656C282073656C6563746F7220293B0A7D3B0A0A66756E6374696F6E20696E697449636F6E73282066612C20705F6469616C6F672C20705F6974656D';
wwv_flow_api.g_varchar2_table(70) := '2C20704F707429207B0A202020207661722024203D2066612E242C0A20202020202020204C203D20274C41524745272C0A202020202020202053203D2027534D414C4C272C0A090949544D203D20705F6974656D207C7C207B726567696F6E49643A2222';
wwv_flow_api.g_varchar2_table(71) := '2C20726F7749643A22222C20636F6C756D6E3A22227D2C0A2020202020202020434C5F4C41524745203D2027666F7263652D66612D6C67272C0A2020202020202020774C6F636174696F6E203D2077696E646F772E6C6F636174696F6E2C0A2020202020';
wwv_flow_api.g_varchar2_table(72) := '20202063757272656E7449636F6E203D20774C6F636174696F6E2E686173682E7265706C61636528202723272C2027272029207C7C202766612D61706578272C0A20202020202020202F2F69734C61726765203D20774C6F636174696F6E2E7365617263';
wwv_flow_api.g_varchar2_table(73) := '682E696E6465784F6628204C2029203E202D312C0A202020202020202069734C617267652C0A202020202020202074696D656F75742C0A20202020202020206170657849636F6E732C0A20202020202020206170657849636F6E4B6579732C0A20202020';
wwv_flow_api.g_varchar2_table(74) := '20202020666C617474656E6564203D205B5D2C0A202020202020202069636F6E7324203D20242820272369636F6E732720293B0A0A20202020766172205F69734C61726765203D2066756E6374696F6E2876616C7565297B0A2020202020202020696628';
wwv_flow_api.g_varchar2_table(75) := '76616C7565297B0A2020202020202020202020207472797B0A202020202020202020202020202020206C6F63616C53746F726167652E7365744974656D28226C617267652E666F6E7461706578222C76616C7565293B0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(76) := '63617463682865297B0A2020202020202020202020202020202069734C61726765203D2076616C75653B0A2020202020202020202020207D0A20202020202020207D656C73657B0A2020202020202020202020207472797B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(77) := '202020202072657475726E206C6F63616C53746F726167652E6765744974656D28226C617267652E666F6E74617065782229207C7C202266616C7365223B0A2020202020202020202020207D63617463682865297B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(78) := '20206966202869734C61726765297B0A202020202020202020202020202020202020202072657475726E2069734C617267653B0A202020202020202020202020202020207D656C73657B0A202020202020202020202020202020202020202069734C6172';
wwv_flow_api.g_varchar2_table(79) := '6765203D202266616C7365223B0A202020202020202020202020202020202020202072657475726E2069734C617267653B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A202020207D0A0A20';
wwv_flow_api.g_varchar2_table(80) := '2020207661722069735072657669657750616765203D2066756E6374696F6E202829207B0A20202020202072657475726E20242820272369636F6E5F707265766965772720292E6C656E677468203E2030203B0A202020207D3B0A0A2020202076617220';
wwv_flow_api.g_varchar2_table(81) := '686967686C69676874203D2066756E6374696F6E20287478742C2073747229207B0A202020202020202072657475726E207478742E7265706C616365286E65772052656745787028222822202B20737472202B202229222C22676922292C20273C737061';
wwv_flow_api.g_varchar2_table(82) := '6E20636C6173733D22686967686C69676874223E24313C2F7370616E3E27293B0A202020207D3B0A0A202020207661722072656E64657249636F6E73203D2066756E6374696F6E28206F70747320297B0A2020202020202020766172206F75747075743B';
wwv_flow_api.g_varchar2_table(83) := '0A0A2020202020202020636C65617254696D656F75742874696D656F7574293B0A2020202020202020766172206465626F756E6365203D206F7074732E6465626F756E6365207C7C2035302C0A2020202020202020202020206B6579203D206F7074732E';
wwv_flow_api.g_varchar2_table(84) := '66696C746572537472696E67207C7C2027272C0A2020202020202020202020206B65794C656E677468203D206B65792E6C656E6774683B0A0A20202020202020206B6579203D206B65792E746F55707065724361736528292E7472696D28293B0A0A2020';
wwv_flow_api.g_varchar2_table(85) := '20202020202076617220617373656D626C6548544D4C203D2066756E6374696F6E2028726573756C745365742C2069636F6E43617465676F727929207B0A2020202020202020202020207661722073697A65203D205F69734C617267652829203D3D3D20';
wwv_flow_api.g_varchar2_table(86) := '277472756527203F204C203A20532C0A20202020202020202020202020202020676574456E747279203D2066756E6374696F6E202820636C2029207B0A202020202020202020202020202020202020202072657475726E20273C6C6920726F6C653D226E';
wwv_flow_api.g_varchar2_table(87) := '617669676174696F6E223E27202B200A202020202020202020202020202020202020202020202020273C6120636C6173733D22646D2D5365617263682D726573756C742220687265663D226A6176617363726970743A636C6F73654469616C6F67495028';
wwv_flow_api.g_varchar2_table(88) := '272B704F70742E69735F677269642B272C5C27272B705F6469616C6F672B275C272C5C27272B49544D2E726567696F6E49642B275C272C5C27272B49544D2E726F7749642B275C272C5C27272B49544D2E636F6C756D6E2B275C272C5C27272B20636C20';
wwv_flow_api.g_varchar2_table(89) := '2B275C27293B2220617269612D6C6162656C6C656462793D2269706C697374223E27202B0A202020202020202020202020202020202020202020202020273C64697620636C6173733D22646D2D5365617263682D69636F6E223E27202B0A202020202020';
wwv_flow_api.g_varchar2_table(90) := '202020202020202020202020202020202020273C7370616E20636C6173733D22742D49636F6E20666120272B20636C202B272220617269612D68696464656E3D2274727565223E3C2F7370616E3E27202B0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(91) := '202020202020273C2F6469763E27202B0A09090909090928704F70742E73686F7749636F6E4C6162656C3F280A202020202020202020202020202020202020202020202020273C64697620636C6173733D22646D2D5365617263682D696E666F223E2720';
wwv_flow_api.g_varchar2_table(92) := '2B0A202020202020202020202020202020202020202020202020273C7370616E20636C6173733D22646D2D5365617263682D636C617373223E272B20636C202B273C2F7370616E3E27202B0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(93) := '273C2F6469763E27293A272729202B0A202020202020202020202020202020202020202020202020273C2F613E27202B0A202020202020202020202020202020202020202020202020273C2F6C693E273B0A202020202020202020202020202020207D3B';
wwv_flow_api.g_varchar2_table(94) := '0A0A2020202020202020202020206966202869636F6E43617465676F727929207B202F2F206B6579776F726473206973206E6F742070726F76696465642C2073686F772065766572797468696E670A202020202020202020202020202020206F75747075';
wwv_flow_api.g_varchar2_table(95) := '74203D206F7574707574202B20273C64697620636C6173733D22646D2D5365617263682D63617465676F7279223E273B0A202020202020202020202020202020206F7574707574203D206F7574707574202B20273C683220636C6173733D22646D2D5365';
wwv_flow_api.g_varchar2_table(96) := '617263682D7469746C65223E27202B2069636F6E43617465676F72792E7265706C616365282F5F2F672C272027292E746F4C6F7765724361736528292B20272049636F6E733C2F68323E273B0A202020202020202020202020202020206F757470757420';
wwv_flow_api.g_varchar2_table(97) := '3D206F7574707574202B20273C756C20636C6173733D22646D2D5365617263682D6C697374222069643D2269706C697374223E273B0A20202020202020202020202020202020726573756C745365742E666F72456163682866756E6374696F6E2869636F';
wwv_flow_api.g_varchar2_table(98) := '6E436C617373297B0A20202020202020202020202020202020202020206F7574707574203D206F7574707574202B20676574456E747279282069636F6E436C6173732E6E616D6520293B0A202020202020202020202020202020207D293B0A2020202020';
wwv_flow_api.g_varchar2_table(99) := '20202020202020202020206F7574707574203D206F7574707574202B20273C2F756C3E273B0A202020202020202020202020202020206F7574707574203D206F7574707574202B20273C2F6469763E273B0A2020202020202020202020207D20656C7365';
wwv_flow_api.g_varchar2_table(100) := '207B0A2020202020202020202020202020202069662028726573756C745365742E6C656E677468203E203029207B0A2020202020202020202020202020202020202020726573756C745365742E666F72456163682866756E6374696F6E202869636F6E43';
wwv_flow_api.g_varchar2_table(101) := '6C61737329207B0A2020202020202020202020202020202020202020202020206F7574707574203D206F7574707574202B20676574456E747279282069636F6E436C6173732E6E616D6520293B0A20202020202020202020202020202020202020207D29';
wwv_flow_api.g_varchar2_table(102) := '3B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D3B0A09090A0A202020202020202076617220736561726368203D2066756E6374696F6E202829207B0A20202020202020202020202069662028';
wwv_flow_api.g_varchar2_table(103) := '6B65792E6C656E677468203D3D3D203129207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A0A20202020202020202020202076617220726573756C74536574203D205B5D2C0A202020202020202020';
wwv_flow_api.g_varchar2_table(104) := '20202020202020726573756C74735469746C65203D2027273B0A0A2020202020202020202020206F7574707574203D2027273B0A0A202020202020202020202020696620286B6579203D3D3D20272729207B202F2F206E6F206B6579776F726473207072';
wwv_flow_api.g_varchar2_table(105) := '6F76696465642C20646973706C617920616C6C2069636F6E732E0A202020202020202020202020202020206170657849636F6E4B6579732E666F72456163682866756E6374696F6E2869636F6E43617465676F7279297B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(106) := '2020202020202020726573756C74536574203D206170657849636F6E735B69636F6E43617465676F72795D2E736F72742866756E6374696F6E2028612C206229207B0A20202020202020202020202020202020202020202020202069662028612E6E616D';
wwv_flow_api.g_varchar2_table(107) := '65203C20622E6E616D6529207B0A2020202020202020202020202020202020202020202020202020202072657475726E202D313B0A2020202020202020202020202020202020202020202020207D20656C73652069662028612E6E616D65203E20622E6E';
wwv_flow_api.g_varchar2_table(108) := '616D6529207B0A2020202020202020202020202020202020202020202020202020202072657475726E20313B0A2020202020202020202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(109) := '20202020202072657475726E20303B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D293B202F2F206E6F206B6579776F7264732C206E6F207365617263682E204A75737420736F';
wwv_flow_api.g_varchar2_table(110) := '72742E0A2020202020202020202020202020202020202020617373656D626C6548544D4C28726573756C745365742C2069636F6E43617465676F7279293B0A202020202020202020202020202020207D293B0A2020202020202020202020207D20656C73';
wwv_flow_api.g_varchar2_table(111) := '65207B0A20202020202020202020202020202020726573756C74536574203D20666C617474656E65642E66696C7465722866756E6374696F6E2863757256616C297B0A2020202020202020202020202020202020202020766172206E616D652020202020';
wwv_flow_api.g_varchar2_table(112) := '3D2063757256616C2E6E616D652E746F55707065724361736528292E736C6963652833292C202F2F2072656D6F76652074686520707265666978202766612D270A2020202020202020202020202020202020202020202020206E616D654172722C0A2020';
wwv_flow_api.g_varchar2_table(113) := '2020202020202020202020202020202020202020202066696C7465727320203D2063757256616C2E66696C74657273203F2063757256616C2E66696C746572732E746F5570706572436173652829203A2027272C0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(114) := '20202020202020202066696C746572734172722C0A2020202020202020202020202020202020202020202020206669727374586C6574746572732C0A20202020202020202020202020202020202020202020202072616E6B203D20302C0A202020202020';
wwv_flow_api.g_varchar2_table(115) := '202020202020202020202020202020202020692C2066696C7465724172724C656E2C206A2C206E616D654172724C656E3B0A0A2020202020202020202020202020202020202020696620286B65792E696E6465784F662827202729203E203029207B0A20';
wwv_flow_api.g_varchar2_table(116) := '20202020202020202020202020202020202020202020206B6579203D206B65792E7265706C616365282720272C20272D27293B0A20202020202020202020202020202020202020207D0A0A2020202020202020202020202020202020202020696620286E';
wwv_flow_api.g_varchar2_table(117) := '616D652E696E6465784F66286B657929203E3D203029207B0A2020202020202020202020202020202020202020202020202F2F20636F6E76657274206E616D657320746F20617272617920666F722072616E6B696E670A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(118) := '20202020202020202020206E616D65417272203D206E616D652E73706C697428272D27293B0A2020202020202020202020202020202020202020202020206E616D654172724C656E203D206E616D654172722E6C656E6774683B0A202020202020202020';
wwv_flow_api.g_varchar2_table(119) := '2020202020202020202020202020202F2F2072616E6B3A20646F65736E2774206861766520222D220A202020202020202020202020202020202020202020202020696620286E616D652E696E6465784F6628272D2729203C203029207B0A202020202020';
wwv_flow_api.g_varchar2_table(120) := '2020202020202020202020202020202020202020202072616E6B202B3D20313030303B0A2020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202F2F2072616E6B3A206D61746368';
wwv_flow_api.g_varchar2_table(121) := '6573207468652077686F6C65206E616D650A202020202020202020202020202020202020202020202020696620286E616D652E6C656E677468203D3D3D206B65794C656E67746829207B0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(122) := '20202072616E6B202B3D20313030303B0A2020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202F2F2072616E6B3A206D617463686573207061727469616C20626567696E6E696E';
wwv_flow_api.g_varchar2_table(123) := '670A2020202020202020202020202020202020202020202020206669727374586C657474657273203D206E616D654172725B305D2E736C69636528302C206B65794C656E677468293B0A2020202020202020202020202020202020202020202020206966';
wwv_flow_api.g_varchar2_table(124) := '20286669727374586C6574746572732E696E6465784F66286B657929203E3D203029207B0A2020202020202020202020202020202020202020202020202020202072616E6B202B3D20313030303B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(125) := '2020207D0A202020202020202020202020202020202020202020202020666F7220286A203D20303B206A203C206E616D654172724C656E3B206A2B2B29207B0A20202020202020202020202020202020202020202020202020202020696620286E616D65';
wwv_flow_api.g_varchar2_table(126) := '4172725B6A5D29207B0A2020202020202020202020202020202020202020202020202020202020202020696620286E616D654172725B6A5D2E696E6465784F66286B657929203E3D203029207B0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(127) := '202020202020202020202020202072616E6B202B3D203130303B0A20202020202020202020202020202020202020202020202020202020202020207D0A202020202020202020202020202020202020202020202020202020207D0A202020202020202020';
wwv_flow_api.g_varchar2_table(128) := '2020202020202020202020202020207D0A20202020202020202020202020202020202020202020202063757256616C2E72616E6B203D2072616E6B3B0A20202020202020202020202020202020202020202020202072657475726E20747275653B0A2020';
wwv_flow_api.g_varchar2_table(129) := '2020202020202020202020202020202020207D0A0A20202020202020202020202020202020202020202F2F20636F6E7665727420776F72647320696E2066696C7465727320746F2061727261790A20202020202020202020202020202020202020206669';
wwv_flow_api.g_varchar2_table(130) := '6C74657273417272203D2066696C746572732E73706C697428272C27293B0A202020202020202020202020202020202020202066696C7465724172724C656E203D2066696C746572734172722E6C656E6774683B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(131) := '20202020202F2F206B6579776F726473206D61746368657320696E2066696C74657273206669656C642E0A2020202020202020202020202020202020202020666F72202869203D20303B2069203C2066696C7465724172724C656E3B2069202B2B29207B';
wwv_flow_api.g_varchar2_table(132) := '0A2020202020202020202020202020202020202020202020206669727374586C657474657273203D2066696C746572734172725B695D2E736C69636528302C206B65794C656E677468293B0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(133) := '696620286669727374586C6574746572732E696E6465784F66286B657929203E3D203029207B0A2020202020202020202020202020202020202020202020202020202063757256616C2E72616E6B203D20313B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(134) := '20202020202020202020202072657475726E20747275653B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A0A202020202020';
wwv_flow_api.g_varchar2_table(135) := '20202020202020202020726573756C745365742E736F72742866756E6374696F6E2028612C206229207B0A2020202020202020202020202020202020202020766172206172203D20612E72616E6B2C0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(136) := '202020206272203D20622E72616E6B3B0A2020202020202020202020202020202020202020696620286172203E20627229207B0A20202020202020202020202020202020202020202020202072657475726E202D313B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(137) := '202020202020207D20656C736520696620286172203C20627229207B0A20202020202020202020202020202020202020202020202072657475726E20313B0A20202020202020202020202020202020202020207D20656C7365207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(138) := '2020202020202020202020202020202072657475726E20303B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A0A20202020202020202020202020202020617373656D626C6548544D4C287265';
wwv_flow_api.g_varchar2_table(139) := '73756C74536574293B0A0A202020202020202020202020202020202F2F2073656172636820726573756C747320554920646F65736E277420726571756972652063617465676F7279207469746C650A20202020202020202020202020202020726573756C';
wwv_flow_api.g_varchar2_table(140) := '74735469746C65203D20726573756C745365742E6C656E677468203D3D3D2030203F20274E6F20726573756C747327203A20726573756C745365742E6C656E677468202B202720526573756C7473273B0A202020202020202020202020202020206F7574';
wwv_flow_api.g_varchar2_table(141) := '707574203D20273C64697620636C6173733D22646D2D5365617263682D63617465676F7279223E27202B0A2020202020202020202020202020202020202020273C683220636C6173733D22646D2D5365617263682D7469746C65223E27202B2072657375';
wwv_flow_api.g_varchar2_table(142) := '6C74735469746C65202B20273C2F68323E27202B0A2020202020202020202020202020202020202020273C756C20636C6173733D22646D2D5365617263682D6C697374222069643D2269706C697374223E27202B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(143) := '20202020206F7574707574202B0A2020202020202020202020202020202020202020273C2F756C3E273B0A202020202020202020202020202020206F7574707574203D206F7574707574202B20273C2F6469763E273B0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(144) := '0A0A2020202020202020202020202F2F2066696E616C6C7920616464206F75747075740A202020202020202020202020646F63756D656E742E676574456C656D656E744279496428202769636F6E732720292E696E6E657248544D4C203D206F75747075';
wwv_flow_api.g_varchar2_table(145) := '743B0A0909090A20202020202020207D3B0A0A202020202020202074696D656F7574203D2073657454696D656F75742866756E6374696F6E2829207B0A20202020202020202020202073656172636828293B0A09090969662028704F70742E7573654963';
wwv_flow_api.g_varchar2_table(146) := '6F6E4C697374290A090909096164644974656D4C6973742827756C2369706C69737427293B0A20202020202020207D2C206465626F756E6365293B0A09090A09090A202020207D3B0A0A2020202076617220746F67676C6553697A65203D2066756E6374';
wwv_flow_api.g_varchar2_table(147) := '696F6E202820746861742C2061666665637465642029207B0A2020202020202020746861742E636865636B6564203D20747275653B0A20202020202020206966202820746861742E76616C7565203D3D3D204C2029207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(148) := '61666665637465642E616464436C6173732820434C5F4C4152474520293B0A2020202020202020202020202F2F69734C61726765203D20747275653B0A2020202020202020202020205F69734C6172676528277472756527293B0A20202020202020207D';
wwv_flow_api.g_varchar2_table(149) := '20656C7365207B0A20202020202020202020202061666665637465642E72656D6F7665436C6173732820434C5F4C4152474520293B0A2020202020202020202020205F69734C61726765282766616C736527293B0A20202020202020207D0A202020207D';
wwv_flow_api.g_varchar2_table(150) := '3B0A0A0976617220646F776E6C6F6453564742746E203D2066756E6374696F6E202829207B0A202020202020202024282027627574746F6E2E70762D427574746F6E2720292E6F6E282027636C69636B272C2066756E6374696F6E202829207B0A202020';
wwv_flow_api.g_varchar2_table(151) := '2020202020202020207661722073697A65203D205F69734C617267652829203D3D3D20277472756527203F204C2E746F4C6F776572436173652829203A20532E746F4C6F7765724361736528293B0A20202020202020202020202077696E646F772E6F70';
wwv_flow_api.g_varchar2_table(152) := '656E2820272E2E2F737667732F27202B2073697A65202B20272F27202B2063757272656E7449636F6E2E7265706C61636528202766612D272C2027272029202B20272E7376672720293B0A20202020202020207D293B0A202020207D3B0A0A090A202020';
wwv_flow_api.g_varchar2_table(153) := '2069662028206973507265766965775061676528292029207B0A202020202020202069662028205F69734C617267652829203D3D3D2027747275652720297B0A202020202020202020202020646F63756D656E742E676574456C656D656E744279496428';
wwv_flow_api.g_varchar2_table(154) := '202769636F6E5F73697A655F6C617267652720292E636865636B6564203D20747275653B0A20202020202020202020202069636F6E73242E616464436C6173732820434C5F4C4152474520293B0A20202020202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(155) := '20202020202020646F63756D656E742E676574456C656D656E744279496428202769636F6E5F73697A655F736D616C6C2720292E636865636B6564203D20747275653B0A20202020202020202020202069636F6E73242E72656D6F7665436C6173732820';
wwv_flow_api.g_varchar2_table(156) := '434C5F4C4152474520293B0A20202020202020207D0A0A2020202020202020696620282063757272656E7449636F6E2029207B0A202020202020202020202020242820272E646D2D49636F6E2D6E616D652720290A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(157) := '202E74657874282063757272656E7449636F6E20293B0A0A202020202020202020202020242820275B646174612D69636F6E5D2720290A202020202020202020202020202020202E72656D6F7665436C61737328202766612D617065782720290A202020';
wwv_flow_api.g_varchar2_table(158) := '202020202020202020202020202E616464436C617373282063757272656E7449636F6E20293B0A0A20202020202020202020202072656E64657249636F6E5072657669657728293B0A202020202020202020202020646F776E6C6F6453564742746E2829';
wwv_flow_api.g_varchar2_table(159) := '3B0A20202020202020207D0A0A20202020202020202F2F2069636F6E2070726576696577206D6F646966696572730A202020202020202024282027696E7075742C2073656C6563742720290A2020202020202020202020202E6F6E2820276368616E6765';
wwv_flow_api.g_varchar2_table(160) := '272C2066756E6374696F6E202829207B0A2020202020202020202020202020202072656E64657249636F6E5072657669657728293B0A2020202020202020202020207D293B0A0A202020207D20656C7365207B0A20202020202020202F2F20496E646578';
wwv_flow_api.g_varchar2_table(161) := '20506167650A202020202020202069662028205F69734C617267652829203D3D3D2027747275652720297B0A202020202020202020202020646F63756D656E742E676574456C656D656E744279496428202769636F6E5F73697A655F6C61726765272029';
wwv_flow_api.g_varchar2_table(162) := '2E636865636B6564203D20747275653B0A20202020202020202020202069636F6E73242E616464436C6173732820434C5F4C4152474520293B0A20202020202020207D20656C7365207B0A202020202020202020202020646F63756D656E742E67657445';
wwv_flow_api.g_varchar2_table(163) := '6C656D656E744279496428202769636F6E5F73697A655F736D616C6C2720292E636865636B6564203D20747275653B0A20202020202020202020202069636F6E73242E72656D6F7665436C6173732820434C5F4C4152474520293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(164) := '7D0A0A2020202020202020696620282066612E69636F6E732029207B0A20202020202020202020202072656E64657249636F6E73287B7D293B0A0A202020202020202020202020666C617474656E6564203D2066756E6374696F6E202829207B0A202020';
wwv_flow_api.g_varchar2_table(165) := '2020202020202020202020202076617220736574203D205B5D3B0A0A202020202020202020202020202020206170657849636F6E73202020203D2066612E69636F6E733B0A202020202020202020202020202020206170657849636F6E4B657973203D20';
wwv_flow_api.g_varchar2_table(166) := '4F626A6563742E6B65797328206170657849636F6E7320293B0A0A202020202020202020202020202020206170657849636F6E4B6579732E666F72456163682866756E6374696F6E2869636F6E43617465676F727929207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(167) := '202020202020202020736574203D207365742E636F6E63617428206170657849636F6E735B69636F6E43617465676F72795D20293B0A202020202020202020202020202020207D293B0A0A2020202020202020202020202020202072657475726E207365';
wwv_flow_api.g_varchar2_table(168) := '743B0A2020202020202020202020207D28293B0A0A20202020202020202020202024282027237365617263682720292E6F6E2820276B65797570272C2066756E6374696F6E202820652029207B0A2020202020202020202020202020202072656E646572';
wwv_flow_api.g_varchar2_table(169) := '49636F6E73287B0A20202020202020202020202020202020202020206465626F756E63653A203235302C0A202020202020202020202020202020202020202066696C746572537472696E673A20652E7461726765742E76616C75650A2020202020202020';
wwv_flow_api.g_varchar2_table(170) := '20202020202020207D293B0A2020202020202020202020207D20293B0A0A2020202020202020202020202F2F2053697A6520546F67676C650A202020202020202020202020242820275B6E616D653D2269636F6E5F73697A65225D2720292E6F6E282027';
wwv_flow_api.g_varchar2_table(171) := '636C69636B272C2066756E6374696F6E202820652029207B0A20202020202020202020202020202020766172206166666563746564456C656D203D202069636F6E73242E6C656E677468203E2030203F2069636F6E7324203A20242820272E646D2D4963';
wwv_flow_api.g_varchar2_table(172) := '6F6E507265766965772720293B0A20202020202020202020202020202020746F67676C6553697A652820746869732C206166666563746564456C656D20293B0A2020202020202020202020207D20293B0A0909090A0909090A20202020202020207D0A20';
wwv_flow_api.g_varchar2_table(173) := '2020207D0A0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(18527458113786567)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_file_name=>'IPdoc.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E204950696E6974286974656D49642C206F707429207B0D0A202076617220696E646578203D20303B0D0A2020636F6E7374206974656D24203D2024282723272B6974656D4964293B0D0A2020636F6E737420737224203D206974656D';
wwv_flow_api.g_varchar2_table(2) := '242E616464436C6173732827752D76682069732D666F63757361626C6527290D0A092E706172656E7428293B0D0A0D0A202066756E6374696F6E2072656E6465722866756C6C2C2076616C756529207B0D0A0976617220705F76616C203D2076616C7565';
wwv_flow_api.g_varchar2_table(3) := '7C7C2266612D6E617669636F6E223B0D0A20202020636F6E7374206F7574203D20617065782E7574696C2E68746D6C4275696C64657228293B0D0A202020206F75742E6D61726B757028273C64697627290D0A2020202020202E617474722827636C6173';
wwv_flow_api.g_varchar2_table(4) := '73272C202769672D6469762D69636F6E2D7069636B657227290D0A2020202020202E6D61726B757028273E3C627574746F6E27290D0A0920202E6174747228276964272C206974656D49642B275F6C6F765F62746E27290D0A0920202E61747472282774';
wwv_flow_api.g_varchar2_table(5) := '797065272C2027627574746F6E27290D0A0920202E617474722827636C617373272C2027742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D2D69636F6E2069672D627574746F6E2D69636F6E2D7069636B657227';
wwv_flow_api.g_varchar2_table(6) := '2B28216F70742E73686F77546578743F272069702D69636F6E2D6F6E6C79273A272729290D0A0920202E6D61726B757028273E3C7370616E27290D0A0920202E617474722827636C617373272C20272069672D7370616E2D69636F6E2D7069636B657220';
wwv_flow_api.g_varchar2_table(7) := '666120272B705F76616C290D0A0920202E617474722827617269612D68696464656E272C2074727565290D0A0920202E6F7074696F6E616C41747472282764697361626C6564272C206F70742E726561644F6E6C79290D0A0920202E6D61726B75702827';
wwv_flow_api.g_varchar2_table(8) := '202F3E3C2F627574746F6E3E3C696E70757427290D0A2020202020202E61747472282774797065272C206F70742E73686F77546578743F2774657874273A2768696464656E27290D0A0920202E617474722827636C617373272C202769672D696E707574';
wwv_flow_api.g_varchar2_table(9) := '2D69636F6E2D7069636B657227290D0A2020202020202E6174747228276964272C206974656D49642B275F272B696E6465782B275F3027290D0A2020202020202E6174747228276E616D65272C206974656D49642B275F272B696E646578290D0A202020';
wwv_flow_api.g_varchar2_table(10) := '2020202E61747472282776616C7565272C2076616C7565290D0A2020202020202E617474722827746162696E646578272C202D31290D0A2020202020202E6F7074696F6E616C41747472282764697361626C6564272C206F70742E726561644F6E6C7929';
wwv_flow_api.g_varchar2_table(11) := '0D0A2020202020202E6D61726B75702827202F3E3C6C6162656C27290D0A2020202020202E617474722827666F72272C206974656D49642B275F272B696E6465782B275F3027290D0A2020202020202E6D61726B757028273E27290D0A2020202020202E';
wwv_flow_api.g_varchar2_table(12) := '636F6E74656E74282727290D0A2020202020202E6D61726B757028273C2F6C6162656C3E27290D0A0920202E6D61726B75702827203C2F6469763E27293B0D0A0D0A20202020696E646578202B3D20313B0D0A0D0A2020202072657475726E206F75742E';
wwv_flow_api.g_varchar2_table(13) := '746F537472696E6728293B0D0A20207D0D0A0D0A0966756E6374696F6E20617474616368427574746F6E636C69636B2829207B0D0A092020242827627574746F6E5B69643D22272B6974656D49642B275F6C6F765F62746E225D2E69672D627574746F6E';
wwv_flow_api.g_varchar2_table(14) := '2D69636F6E2D7069636B657227292E656163682866756E6374696F6E28692C206529207B0D0A0909242865292E6F6E2827636C69636B272C2066756E6374696F6E286B29207B0D0A090909636F6E737420696E70757424203D20242865292E706172656E';
wwv_flow_api.g_varchar2_table(15) := '7428292E66696E642827696E7075742E696769636F6E7069636B65723A666972737427293B0D0A090909636F6E737420726F774964203D20696E707574242E636C6F736573742827747227292E646174612827696427293B0D0A090909636F6E73742072';
wwv_flow_api.g_varchar2_table(16) := '6567696F6E4964203D202428696E707574242E706172656E747328272E612D49472729292E617474722827696427292E736C69636528302C202D33293B0D0A090909202428222349636F6E5069636B65724469616C6F67426F7822292E6469616C6F6728';
wwv_flow_api.g_varchar2_table(17) := '226F7074696F6E222C20226D6F64616C4974656D222C2074727565290D0A0909090909090909092E6469616C6F6728226F7074696F6E222C20227769647468222C206F70742E70445769647468290D0A0909090909090909092E6469616C6F6728226F70';
wwv_flow_api.g_varchar2_table(18) := '74696F6E222C2022686569676874222C206F70742E7044486569676874290D0A0909090909090909092E6469616C6F6728226F7074696F6E222C20227469746C65222C206F70742E70445469746C65290D0A0909090909090909092E6469616C6F672822';
wwv_flow_api.g_varchar2_table(19) := '6F7074696F6E222C2022726573697A61626C65222C206F70742E705265737A6965290D0A0909090909090909092E6469616C6F6728226F7074696F6E222C20227469726767456C656D222C206974656D4964290D0A0909090909090909092E6469616C6F';
wwv_flow_api.g_varchar2_table(20) := '6728226F7074696F6E222C202273686F7749636F6E4C6162656C222C206F70742E7049636F6E4C6162656C73290D0A0909090909090909092E6469616C6F6728226F7074696F6E222C202274697267674974656D222C207B726567696F6E49643A726567';
wwv_flow_api.g_varchar2_table(21) := '696F6E49642C20726F7749643A726F7749642C20636F6C756D6E3A6974656D49647D290D0A0909090909090909092E68746D6C28273C6D61696E20636C6173733D22646D2D426F6479223E3C64697620636C6173733D22646D2D436F6E7461696E657222';
wwv_flow_api.g_varchar2_table(22) := '3E3C64697620636C6173733D22646D2D536561726368426F78223E3C6C6162656C20636C6173733D22646D2D41636365737369626C6548696464656E2220666F723D22736561726368223E5365617263683C2F6C6162656C3E3C64697620636C6173733D';
wwv_flow_api.g_varchar2_table(23) := '22646D2D536561726368426F782D77726170223E3C7370616E20636C6173733D22646D2D536561726368426F782D69636F6E2066612066612D7365617263682220617269612D68696464656E3D2274727565223E3C2F7370616E3E3C696E707574206964';
wwv_flow_api.g_varchar2_table(24) := '3D227365617263682220636C6173733D22646D2D536561726368426F782D696E7075742220747970653D227365617263682220706C616365686F6C6465723D22272B6F70742E7044706C616365686F6C6465722B272220617269612D636F6E74726F6C73';
wwv_flow_api.g_varchar2_table(25) := '3D2269636F6E7322202F3E3C2F6469763E3C64697620636C6173733D22646D2D536561726368426F782D73657474696E6773223E3C64697620636C6173733D22646D2D526164696F50696C6C53657420646D2D526164696F50696C6C5365742D2D6C6172';
wwv_flow_api.g_varchar2_table(26) := '67652220726F6C653D2267726F75702220617269612D6C6162656C3D2249636F6E2053697A65223E3C64697620636C6173733D22646D2D526164696F50696C6C5365742D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D22';
wwv_flow_api.g_varchar2_table(27) := '69636F6E5F73697A655F736D616C6C22206E616D653D2269636F6E5F73697A65222076616C75653D22534D414C4C223E3C6C6162656C20666F723D2269636F6E5F73697A655F736D616C6C223E272B6F70742E7044736D616C6C2B273C2F6C6162656C3E';
wwv_flow_api.g_varchar2_table(28) := '3C2F6469763E3C64697620636C6173733D22646D2D526164696F50696C6C5365742D6F7074696F6E223E3C696E70757420747970653D22726164696F222069643D2269636F6E5F73697A655F6C6172676522206E616D653D2269636F6E5F73697A652220';
wwv_flow_api.g_varchar2_table(29) := '76616C75653D224C41524745223E3C6C6162656C20666F723D2269636F6E5F73697A655F6C61726765223E272B6F70742E70446C617267652B273C2F6C6162656C3E3C2F6469763E3C2F6469763E3C2F6469763E3C2F6469763E3C6469762069643D2269';
wwv_flow_api.g_varchar2_table(30) := '636F6E732220636C6173733D22646D2D5365617263682220726F6C653D22726567696F6E2220617269612D6C6976653D22706F6C697465223E3C2F6469763E3C2F6469763E3C2F6D61696E3E27290D0A0909090909090909092E6469616C6F6728226F70';
wwv_flow_api.g_varchar2_table(31) := '656E22293B0D0A09097D293B0D0A0920207D293B0D0A097D3B0D0A0D0A20200D0A202069662028216F70742E726561644F6E6C7929207B0D0A20202020617474616368427574746F6E636C69636B28293B200D0A096974656D242E636C6F736573742827';
wwv_flow_api.g_varchar2_table(32) := '2E69672D627574746F6E2D69636F6E2D7069636B657227292E70726F70282764697361626C6564272C2074727565293B0D0A202020206974656D242E70726F70282764697361626C6564272C2074727565293B0D0A20207D0D0A0D0A09200D0A20200D0A';
wwv_flow_api.g_varchar2_table(33) := '2020617065782E6974656D2E637265617465286974656D49642C207B0D0A2020202073657456616C75653A66756E6374696F6E2876616C756529207B0D0A2020202020206974656D242E76616C2876616C7565293B0D0A0920206966202876616C756529';
wwv_flow_api.g_varchar2_table(34) := '0D0A09096974656D242E636C6F7365737428276469762E69672D6469762D69636F6E2D7069636B657227292E66696E6428277370616E2E69672D7370616E2D69636F6E2D7069636B657227292E617474722827636C617373272C2027617065782D697465';
wwv_flow_api.g_varchar2_table(35) := '6D2D69636F6E2069672D7370616E2D69636F6E2D7069636B657220666120272B76616C7565293B0D0A092020656C73650D0A09096974656D242E636C6F7365737428276469762E69672D6469762D69636F6E2D7069636B657227292E66696E6428277370';
wwv_flow_api.g_varchar2_table(36) := '616E2E69672D7370616E2D69636F6E2D7069636B657227292E617474722827636C617373272C2027617065782D6974656D2D69636F6E2069672D7370616E2D69636F6E2D7069636B657220666120272B6F70742E64656649636F6E293B20200D0A202020';
wwv_flow_api.g_varchar2_table(37) := '207D2C0D0A2020202064697361626C653A66756E6374696F6E2829207B0D0A2020202020206974656D242E636C6F7365737428272E69672D6469762D69636F6E2D7069636B657227292E72656D6F7665436C617373282769672D6469762D69636F6E2D70';
wwv_flow_api.g_varchar2_table(38) := '69636B65722D656E61626C656427293B0D0A0920206974656D242E636C6F7365737428272E69672D6469762D69636F6E2D7069636B657227292E616464436C617373282769672D6469762D69636F6E2D7069636B65722D64697361626C656427293B0D0A';
wwv_flow_api.g_varchar2_table(39) := '0920206974656D242E636C6F7365737428272E69672D627574746F6E2D69636F6E2D7069636B657227292E70726F70282764697361626C6564272C2074727565293B0D0A2020202020206974656D242E70726F70282764697361626C6564272C20747275';
wwv_flow_api.g_varchar2_table(40) := '65293B0D0A202020207D2C0D0A20202020656E61626C653A66756E6374696F6E2829207B0D0A20202020202069662028216F70742E726561644F6E6C7929207B0D0A09096974656D242E636C6F7365737428272E69672D6469762D69636F6E2D7069636B';
wwv_flow_api.g_varchar2_table(41) := '657227292E72656D6F7665436C617373282769672D6469762D69636F6E2D7069636B65722D64697361626C656427293B0D0A09096974656D242E636C6F7365737428272E69672D6469762D69636F6E2D7069636B657227292E616464436C617373282769';
wwv_flow_api.g_varchar2_table(42) := '672D6469762D69636F6E2D7069636B65722D656E61626C656427293B0D0A09096974656D242E636C6F7365737428272E69672D627574746F6E2D69636F6E2D7069636B657227292E70726F70282764697361626C6564272C2066616C7365293B0D0A2020';
wwv_flow_api.g_varchar2_table(43) := '2020202020206974656D242E70726F70282764697361626C6564272C2066616C7365293B0D0A2020202020207D0D0A202020207D2C0D0A20202020646973706C617956616C7565466F723A66756E6374696F6E2876616C756529207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(44) := '72657475726E2072656E64657228747275652C2076616C7565293B0D0A202020207D2C0D0A20207D293B0D0A20200D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(18527776671786574)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_file_name=>'IPgrid.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220666F6E7461706578203D207B7D3B0A0A666F6E74617065782E69636F6E733D7B0A20204143434553534942494C4954593A5B7B6E616D653A2266612D616D65726963616E2D7369676E2D6C616E67756167652D696E74657270726574696E6722';
wwv_flow_api.g_varchar2_table(2) := '7D2C7B6E616D653A2266612D61736C2D696E74657270726574696E67227D2C7B6E616D653A2266612D6173736973746976652D6C697374656E696E672D73797374656D73227D2C7B6E616D653A2266612D617564696F2D6465736372697074696F6E227D';
wwv_flow_api.g_varchar2_table(3) := '2C7B6E616D653A2266612D626C696E64227D2C7B6E616D653A2266612D627261696C6C65227D2C7B6E616D653A2266612D64656166227D2C7B6E616D653A2266612D646561666E657373227D2C7B6E616D653A2266612D686172642D6F662D6865617269';
wwv_flow_api.g_varchar2_table(4) := '6E67227D2C7B6E616D653A2266612D6C6F772D766973696F6E227D2C7B6E616D653A2266612D7369676E2D6C616E6775616765227D2C7B6E616D653A2266612D7369676E696E67227D2C7B6E616D653A2266612D756E6976657273616C2D616363657373';
wwv_flow_api.g_varchar2_table(5) := '227D2C7B6E616D653A2266612D766F6C756D652D636F6E74726F6C2D70686F6E65227D2C7B6E616D653A2266612D776865656C63686169722D616C74227D5D2C0A202043414C454E4441523A5B7B6E616D653A2266612D63616C656E6461722D616C6172';
wwv_flow_api.g_varchar2_table(6) := '6D227D2C7B6E616D653A2266612D63616C656E6461722D6172726F772D646F776E227D2C7B6E616D653A2266612D63616C656E6461722D6172726F772D7570227D2C7B6E616D653A2266612D63616C656E6461722D62616E227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(7) := '2D63616C656E6461722D6368617274227D2C7B6E616D653A2266612D63616C656E6461722D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D63616C656E6461722D65646974222C66696C746572733A2270656E';
wwv_flow_api.g_varchar2_table(8) := '63696C227D2C7B6E616D653A2266612D63616C656E6461722D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D63616C656E6461722D6C6F636B227D2C7B6E616D653A2266612D63616C656E6461';
wwv_flow_api.g_varchar2_table(9) := '722D706F696E746572227D2C7B6E616D653A2266612D63616C656E6461722D736561726368227D2C7B6E616D653A2266612D63616C656E6461722D75736572227D2C7B6E616D653A2266612D63616C656E6461722D7772656E6368227D5D2C0A20204348';
wwv_flow_api.g_varchar2_table(10) := '4152543A5B7B6E616D653A2266612D617265612D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D6261722D6368617274222C66696C746572733A2262617263686172746F2C67726170682C';
wwv_flow_api.g_varchar2_table(11) := '616E616C7974696373227D2C7B6E616D653A2266612D6261722D63686172742D686F72697A6F6E74616C227D2C7B6E616D653A2266612D626F782D706C6F742D6368617274227D2C7B6E616D653A2266612D627562626C652D6368617274227D2C7B6E61';
wwv_flow_api.g_varchar2_table(12) := '6D653A2266612D636F6D626F2D6368617274227D2C7B6E616D653A2266612D6469616C2D67617567652D6368617274227D2C7B6E616D653A2266612D646F6E75742D6368617274227D2C7B6E616D653A2266612D66756E6E656C2D6368617274227D2C7B';
wwv_flow_api.g_varchar2_table(13) := '6E616D653A2266612D67616E74742D6368617274227D2C7B6E616D653A2266612D6C696E652D617265612D6368617274227D2C7B6E616D653A2266612D6C696E652D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C';
wwv_flow_api.g_varchar2_table(14) := '7B6E616D653A2266612D7069652D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D7069652D63686172742D30227D2C7B6E616D653A2266612D7069652D63686172742D3130227D2C7B6E61';
wwv_flow_api.g_varchar2_table(15) := '6D653A2266612D7069652D63686172742D313030227D2C7B6E616D653A2266612D7069652D63686172742D3135227D2C7B6E616D653A2266612D7069652D63686172742D3230227D2C7B6E616D653A2266612D7069652D63686172742D3235227D2C7B6E';
wwv_flow_api.g_varchar2_table(16) := '616D653A2266612D7069652D63686172742D3330227D2C7B6E616D653A2266612D7069652D63686172742D3335227D2C7B6E616D653A2266612D7069652D63686172742D3430227D2C7B6E616D653A2266612D7069652D63686172742D3435227D2C7B6E';
wwv_flow_api.g_varchar2_table(17) := '616D653A2266612D7069652D63686172742D35227D2C7B6E616D653A2266612D7069652D63686172742D3530227D2C7B6E616D653A2266612D7069652D63686172742D3535227D2C7B6E616D653A2266612D7069652D63686172742D3630227D2C7B6E61';
wwv_flow_api.g_varchar2_table(18) := '6D653A2266612D7069652D63686172742D3635227D2C7B6E616D653A2266612D7069652D63686172742D3730227D2C7B6E616D653A2266612D7069652D63686172742D3735227D2C7B6E616D653A2266612D7069652D63686172742D3830227D2C7B6E61';
wwv_flow_api.g_varchar2_table(19) := '6D653A2266612D7069652D63686172742D3835227D2C7B6E616D653A2266612D7069652D63686172742D3930227D2C7B6E616D653A2266612D7069652D63686172742D3935227D2C7B6E616D653A2266612D706F6C61722D6368617274227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(20) := '653A2266612D707972616D69642D6368617274227D2C7B6E616D653A2266612D72616461722D6368617274227D2C7B6E616D653A2266612D72616E67652D63686172742D61726561227D2C7B6E616D653A2266612D72616E67652D63686172742D626172';
wwv_flow_api.g_varchar2_table(21) := '227D2C7B6E616D653A2266612D736361747465722D6368617274227D2C7B6E616D653A2266612D73746F636B2D6368617274227D2C7B6E616D653A2266612D782D61786973227D2C7B6E616D653A2266612D792D61786973227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(22) := '2D79312D61786973227D2C7B6E616D653A2266612D79322D61786973227D5D2C0A202043555252454E43593A5B7B6E616D653A2266612D626974636F696E227D2C7B6E616D653A2266612D627463227D2C7B6E616D653A2266612D636E79222C66696C74';
wwv_flow_api.g_varchar2_table(23) := '6572733A226368696E612C72656E6D696E62692C7975616E227D2C7B6E616D653A2266612D646F6C6C6172222C66696C746572733A22757364227D2C7B6E616D653A2266612D657572222C66696C746572733A226575726F227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(24) := '2D6575726F222C66696C746572733A226575726F227D2C7B6E616D653A2266612D676270227D2C7B6E616D653A2266612D696C73222C66696C746572733A227368656B656C2C73686571656C227D2C7B6E616D653A2266612D696E72222C66696C746572';
wwv_flow_api.g_varchar2_table(25) := '733A227275706565227D2C7B6E616D653A2266612D6A7079222C66696C746572733A226A6170616E2C79656E227D2C7B6E616D653A2266612D6B7277222C66696C746572733A22776F6E227D2C7B6E616D653A2266612D6D6F6E6579222C66696C746572';
wwv_flow_api.g_varchar2_table(26) := '733A22636173682C6D6F6E65792C6275792C636865636B6F75742C70757263686173652C7061796D656E74227D2C7B6E616D653A2266612D726D62222C66696C746572733A226368696E612C72656E6D696E62692C7975616E227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(27) := '612D727562222C66696C746572733A227275626C652C726F75626C65227D2C7B6E616D653A2266612D747279222C66696C746572733A227475726B65792C206C6972612C207475726B697368227D2C7B6E616D653A2266612D757364222C66696C746572';
wwv_flow_api.g_varchar2_table(28) := '733A22646F6C6C6172227D2C7B6E616D653A2266612D79656E227D5D2C0A2020444952454354494F4E414C3A5B7B6E616D653A2266612D616E676C652D646F75626C652D646F776E227D2C7B6E616D653A2266612D616E676C652D646F75626C652D6C65';
wwv_flow_api.g_varchar2_table(29) := '6674222C66696C746572733A226C6171756F2C71756F74652C70726576696F75732C6261636B227D2C7B6E616D653A2266612D616E676C652D646F75626C652D7269676874222C66696C746572733A22726171756F2C71756F74652C6E6578742C666F72';
wwv_flow_api.g_varchar2_table(30) := '77617264227D2C7B6E616D653A2266612D616E676C652D646F75626C652D7570227D2C7B6E616D653A2266612D616E676C652D646F776E227D2C7B6E616D653A2266612D616E676C652D6C656674222C66696C746572733A2270726576696F75732C6261';
wwv_flow_api.g_varchar2_table(31) := '636B227D2C7B6E616D653A2266612D616E676C652D7269676874222C66696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D616E676C652D7570227D2C7B6E616D653A2266612D6172726F772D636972636C652D646F776E';
wwv_flow_api.g_varchar2_table(32) := '222C66696C746572733A22646F776E6C6F6164227D2C7B6E616D653A2266612D6172726F772D636972636C652D6C656674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D6172726F772D636972636C652D6F';
wwv_flow_api.g_varchar2_table(33) := '2D646F776E222C66696C746572733A22646F776E6C6F6164227D2C7B6E616D653A2266612D6172726F772D636972636C652D6F2D6C656674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D6172726F772D63';
wwv_flow_api.g_varchar2_table(34) := '6972636C652D6F2D7269676874222C66696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D6172726F772D636972636C652D6F2D7570227D2C7B6E616D653A2266612D6172726F772D636972636C652D7269676874222C66';
wwv_flow_api.g_varchar2_table(35) := '696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D6172726F772D636972636C652D7570227D2C7B6E616D653A2266612D6172726F772D646F776E222C66696C746572733A22646F776E6C6F6164227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(36) := '66612D6172726F772D646F776E2D616C74227D2C7B6E616D653A2266612D6172726F772D646F776E2D6C6566742D616C74227D2C7B6E616D653A2266612D6172726F772D646F776E2D72696768742D616C74227D2C7B6E616D653A2266612D6172726F77';
wwv_flow_api.g_varchar2_table(37) := '2D6C656674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D6172726F772D6C6566742D616C74227D2C7B6E616D653A2266612D6172726F772D7269676874222C66696C746572733A226E6578742C666F7277';
wwv_flow_api.g_varchar2_table(38) := '617264227D2C7B6E616D653A2266612D6172726F772D72696768742D616C74227D2C7B6E616D653A2266612D6172726F772D7570227D2C7B6E616D653A2266612D6172726F772D75702D616C74227D2C7B6E616D653A2266612D6172726F772D75702D6C';
wwv_flow_api.g_varchar2_table(39) := '6566742D616C74227D2C7B6E616D653A2266612D6172726F772D75702D72696768742D616C74227D2C7B6E616D653A2266612D6172726F7773222C66696C746572733A226D6F76652C72656F726465722C726573697A65227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(40) := '6172726F77732D616C74222C66696C746572733A22657870616E642C656E6C617267652C66756C6C73637265656E2C6269676765722C6D6F76652C72656F726465722C726573697A65227D2C7B6E616D653A2266612D6172726F77732D68222C66696C74';
wwv_flow_api.g_varchar2_table(41) := '6572733A22726573697A65227D2C7B6E616D653A2266612D6172726F77732D76222C66696C746572733A22726573697A65227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D65617374227D2C7B6E616D653A2266612D626F782D6172726F';
wwv_flow_api.g_varchar2_table(42) := '772D696E2D6E65227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D6E6F727468227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D6E77227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D7365227D2C7B6E61';
wwv_flow_api.g_varchar2_table(43) := '6D653A2266612D626F782D6172726F772D696E2D736F757468227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D7377227D2C7B6E616D653A2266612D626F782D6172726F772D696E2D77657374227D2C7B6E616D653A2266612D626F782D';
wwv_flow_api.g_varchar2_table(44) := '6172726F772D6F75742D65617374227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D6E65227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D6E6F727468227D2C7B6E616D653A2266612D626F782D6172726F772D6F75';
wwv_flow_api.g_varchar2_table(45) := '742D6E77227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D7365227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D736F757468227D2C7B6E616D653A2266612D626F782D6172726F772D6F75742D7377227D2C7B6E61';
wwv_flow_api.g_varchar2_table(46) := '6D653A2266612D626F782D6172726F772D6F75742D77657374227D2C7B6E616D653A2266612D63617265742D646F776E222C66696C746572733A226D6F72652C64726F70646F776E2C6D656E752C747269616E676C65646F776E227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(47) := '66612D63617265742D6C656674222C66696C746572733A2270726576696F75732C6261636B2C747269616E676C656C656674227D2C7B6E616D653A2266612D63617265742D7269676874222C66696C746572733A226E6578742C666F72776172642C7472';
wwv_flow_api.g_varchar2_table(48) := '69616E676C657269676874227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D646F776E222C66696C746572733A22746F67676C65646F776E2C6D6F72652C64726F70646F776E2C6D656E75227D2C7B6E616D653A2266612D63617265';
wwv_flow_api.g_varchar2_table(49) := '742D7371756172652D6F2D6C656674222C66696C746572733A2270726576696F75732C6261636B2C746F67676C656C656674227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D7269676874222C66696C746572733A226E6578742C66';
wwv_flow_api.g_varchar2_table(50) := '6F72776172642C746F67676C657269676874227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D7570222C66696C746572733A22746F67676C657570227D2C7B6E616D653A2266612D63617265742D7570222C66696C746572733A2274';
wwv_flow_api.g_varchar2_table(51) := '7269616E676C657570227D2C7B6E616D653A2266612D63686576726F6E2D636972636C652D646F776E222C66696C746572733A226D6F72652C64726F70646F776E2C6D656E75227D2C7B6E616D653A2266612D63686576726F6E2D636972636C652D6C65';
wwv_flow_api.g_varchar2_table(52) := '6674222C66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D63686576726F6E2D636972636C652D7269676874222C66696C746572733A226E6578742C666F7277617264227D2C7B6E616D653A2266612D6368657672';
wwv_flow_api.g_varchar2_table(53) := '6F6E2D636972636C652D7570227D2C7B6E616D653A2266612D63686576726F6E2D646F776E227D2C7B6E616D653A2266612D63686576726F6E2D6C656674222C66696C746572733A22627261636B65742C70726576696F75732C6261636B227D2C7B6E61';
wwv_flow_api.g_varchar2_table(54) := '6D653A2266612D63686576726F6E2D7269676874222C66696C746572733A22627261636B65742C6E6578742C666F7277617264227D2C7B6E616D653A2266612D63686576726F6E2D7570227D2C7B6E616D653A2266612D636972636C652D6172726F772D';
wwv_flow_api.g_varchar2_table(55) := '696E2D65617374227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D6E65227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D6E6F727468227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E';
wwv_flow_api.g_varchar2_table(56) := '2D6E77227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D7365227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D736F757468227D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D737722';
wwv_flow_api.g_varchar2_table(57) := '7D2C7B6E616D653A2266612D636972636C652D6172726F772D696E2D77657374227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D65617374227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D6E65227D';
wwv_flow_api.g_varchar2_table(58) := '2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D6E6F727468227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D6E77227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D7365227D2C';
wwv_flow_api.g_varchar2_table(59) := '7B6E616D653A2266612D636972636C652D6172726F772D6F75742D736F757468227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D7377227D2C7B6E616D653A2266612D636972636C652D6172726F772D6F75742D77657374227D';
wwv_flow_api.g_varchar2_table(60) := '2C7B6E616D653A2266612D65786368616E6765222C66696C746572733A227472616E736665722C6172726F7773227D2C7B6E616D653A2266612D68616E642D6F2D646F776E222C66696C746572733A22706F696E74227D2C7B6E616D653A2266612D6861';
wwv_flow_api.g_varchar2_table(61) := '6E642D6F2D6C656674222C66696C746572733A22706F696E742C6C6566742C70726576696F75732C6261636B227D2C7B6E616D653A2266612D68616E642D6F2D7269676874222C66696C746572733A22706F696E742C72696768742C6E6578742C666F72';
wwv_flow_api.g_varchar2_table(62) := '77617264227D2C7B6E616D653A2266612D68616E642D6F2D7570222C66696C746572733A22706F696E74227D2C7B6E616D653A2266612D6C6F6E672D6172726F772D646F776E227D2C7B6E616D653A2266612D6C6F6E672D6172726F772D6C656674222C';
wwv_flow_api.g_varchar2_table(63) := '66696C746572733A2270726576696F75732C6261636B227D2C7B6E616D653A2266612D6C6F6E672D6172726F772D7269676874227D2C7B6E616D653A2266612D6C6F6E672D6172726F772D7570227D2C7B6E616D653A2266612D706167652D626F74746F';
wwv_flow_api.g_varchar2_table(64) := '6D227D2C7B6E616D653A2266612D706167652D6669727374227D2C7B6E616D653A2266612D706167652D6C617374227D2C7B6E616D653A2266612D706167652D746F70227D5D2C0A2020454D4F4A493A5B7B6E616D653A2266612D617765736F6D652D66';
wwv_flow_api.g_varchar2_table(65) := '616365227D2C7B6E616D653A2266612D656D6F6A692D616E677279227D2C7B6E616D653A2266612D656D6F6A692D6173746F6E6973686564227D2C7B6E616D653A2266612D656D6F6A692D6269672D657965732D736D696C65227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(66) := '612D656D6F6A692D6269672D66726F776E227D2C7B6E616D653A2266612D656D6F6A692D636F6C642D7377656174227D2C7B6E616D653A2266612D656D6F6A692D636F6E666F756E646564227D2C7B6E616D653A2266612D656D6F6A692D636F6E667573';
wwv_flow_api.g_varchar2_table(67) := '6564227D2C7B6E616D653A2266612D656D6F6A692D636F6F6C227D2C7B6E616D653A2266612D656D6F6A692D6372696E6765227D2C7B6E616D653A2266612D656D6F6A692D637279227D2C7B6E616D653A2266612D656D6F6A692D64656C6963696F7573';
wwv_flow_api.g_varchar2_table(68) := '227D2C7B6E616D653A2266612D656D6F6A692D6469736170706F696E746564227D2C7B6E616D653A2266612D656D6F6A692D6469736170706F696E7465642D72656C6965766564227D2C7B6E616D653A2266612D656D6F6A692D65787072657373696F6E';
wwv_flow_api.g_varchar2_table(69) := '6C657373227D2C7B6E616D653A2266612D656D6F6A692D6665617266756C227D2C7B6E616D653A2266612D656D6F6A692D66726F776E227D2C7B6E616D653A2266612D656D6F6A692D6772696D616365227D2C7B6E616D653A2266612D656D6F6A692D67';
wwv_flow_api.g_varchar2_table(70) := '72696E2D7377656174227D2C7B6E616D653A2266612D656D6F6A692D68617070792D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D687573686564227D2C7B6E616D653A2266612D656D6F6A692D6C61756768696E67227D2C7B6E616D653A';
wwv_flow_api.g_varchar2_table(71) := '2266612D656D6F6A692D6C6F6C227D2C7B6E616D653A2266612D656D6F6A692D6C6F7665227D2C7B6E616D653A2266612D656D6F6A692D6D65616E227D2C7B6E616D653A2266612D656D6F6A692D6E657264227D2C7B6E616D653A2266612D656D6F6A69';
wwv_flow_api.g_varchar2_table(72) := '2D6E65757472616C227D2C7B6E616D653A2266612D656D6F6A692D6E6F2D6D6F757468227D2C7B6E616D653A2266612D656D6F6A692D6F70656E2D6D6F757468227D2C7B6E616D653A2266612D656D6F6A692D70656E73697665227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(73) := '66612D656D6F6A692D706572736576657265227D2C7B6E616D653A2266612D656D6F6A692D706C6561736564227D2C7B6E616D653A2266612D656D6F6A692D72656C6965766564227D2C7B6E616D653A2266612D656D6F6A692D726F74666C227D2C7B6E';
wwv_flow_api.g_varchar2_table(74) := '616D653A2266612D656D6F6A692D73637265616D227D2C7B6E616D653A2266612D656D6F6A692D736C656570696E67227D2C7B6E616D653A2266612D656D6F6A692D736C65657079227D2C7B6E616D653A2266612D656D6F6A692D736C696768742D6672';
wwv_flow_api.g_varchar2_table(75) := '6F776E227D2C7B6E616D653A2266612D656D6F6A692D736C696768742D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D736D69726B227D2C7B6E616D653A2266612D656D6F6A69';
wwv_flow_api.g_varchar2_table(76) := '2D737475636B2D6F75742D746F756E6765227D2C7B6E616D653A2266612D656D6F6A692D737475636B2D6F75742D746F756E67652D636C6F7365642D65796573227D2C7B6E616D653A2266612D656D6F6A692D737475636B2D6F75742D746F756E67652D';
wwv_flow_api.g_varchar2_table(77) := '77696E6B227D2C7B6E616D653A2266612D656D6F6A692D73776565742D736D696C65227D2C7B6E616D653A2266612D656D6F6A692D7469726564227D2C7B6E616D653A2266612D656D6F6A692D756E616D75736564227D2C7B6E616D653A2266612D656D';
wwv_flow_api.g_varchar2_table(78) := '6F6A692D7570736964652D646F776E227D2C7B6E616D653A2266612D656D6F6A692D7765617279227D2C7B6E616D653A2266612D656D6F6A692D77696E6B227D2C7B6E616D653A2266612D656D6F6A692D776F727279227D2C7B6E616D653A2266612D65';
wwv_flow_api.g_varchar2_table(79) := '6D6F6A692D7A69707065722D6D6F757468227D2C7B6E616D653A2266612D68697073746572227D5D2C0A202046494C455F545950453A5B7B6E616D653A2266612D66696C65222C66696C746572733A226E65772C706167652C7064662C646F63756D656E';
wwv_flow_api.g_varchar2_table(80) := '74227D2C7B6E616D653A2266612D66696C652D617263686976652D6F222C66696C746572733A227A6970227D2C7B6E616D653A2266612D66696C652D617564696F2D6F222C66696C746572733A22736F756E64227D2C7B6E616D653A2266612D66696C65';
wwv_flow_api.g_varchar2_table(81) := '2D636F64652D6F227D2C7B6E616D653A2266612D66696C652D657863656C2D6F227D2C7B6E616D653A2266612D66696C652D696D6167652D6F222C66696C746572733A2270686F746F2C70696374757265227D2C7B6E616D653A2266612D66696C652D6F';
wwv_flow_api.g_varchar2_table(82) := '222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D7064662D6F227D2C7B6E616D653A2266612D66696C652D706F776572706F696E742D6F227D2C7B6E616D653A2266612D6669';
wwv_flow_api.g_varchar2_table(83) := '6C652D73716C227D2C7B6E616D653A2266612D66696C652D74657874222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D746578742D6F222C66696C746572733A226E65772C70';
wwv_flow_api.g_varchar2_table(84) := '6167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D766964656F2D6F222C66696C746572733A2266696C656D6F7669656F227D2C7B6E616D653A2266612D66696C652D776F72642D6F227D5D2C0A2020464F524D5F434F';
wwv_flow_api.g_varchar2_table(85) := '4E54524F4C3A5B7B6E616D653A2266612D636865636B2D737175617265222C66696C746572733A22636865636B6D61726B2C646F6E652C746F646F2C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D73';
wwv_flow_api.g_varchar2_table(86) := '71756172652D6F222C66696C746572733A22746F646F2C646F6E652C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636972636C65222C66696C746572733A22646F742C6E6F74696669636174696F6E227D2C7B6E61';
wwv_flow_api.g_varchar2_table(87) := '6D653A2266612D636972636C652D6F227D2C7B6E616D653A2266612D646F742D636972636C652D6F222C66696C746572733A227461726765742C62756C6C736579652C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D6D696E75732D7371';
wwv_flow_api.g_varchar2_table(88) := '75617265222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964652C636F6C6C61707365227D2C7B6E616D653A2266612D6D696E75732D7371756172652D6F222C66696C746572733A226869';
wwv_flow_api.g_varchar2_table(89) := '64652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964652C636F6C6C61707365227D2C7B6E616D653A2266612D706C75732D737175617265222C66696C746572733A226164642C6E65772C6372656174652C657870616E6422';
wwv_flow_api.g_varchar2_table(90) := '7D2C7B6E616D653A2266612D706C75732D7371756172652D6F222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D737175617265222C66696C746572733A22626C6F636B2C626F78227D2C7B';
wwv_flow_api.g_varchar2_table(91) := '6E616D653A2266612D7371756172652D6F222C66696C746572733A22626C6F636B2C7371756172652C626F78227D2C7B6E616D653A2266612D7371756172652D73656C65637465642D6F222C66696C746572733A22626C6F636B2C7371756172652C626F';
wwv_flow_api.g_varchar2_table(92) := '78227D2C7B6E616D653A2266612D74696D65732D737175617265222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D74696D65732D7371756172652D6F222C66696C';
wwv_flow_api.g_varchar2_table(93) := '746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D5D2C0A202047454E4445523A5B7B6E616D653A2266612D67656E6465726C657373227D2C7B6E616D653A2266612D6D617273222C66696C746572733A22';
wwv_flow_api.g_varchar2_table(94) := '6D616C65227D2C7B6E616D653A2266612D6D6172732D646F75626C65227D2C7B6E616D653A2266612D6D6172732D7374726F6B65227D2C7B6E616D653A2266612D6D6172732D7374726F6B652D68227D2C7B6E616D653A2266612D6D6172732D7374726F';
wwv_flow_api.g_varchar2_table(95) := '6B652D76227D2C7B6E616D653A2266612D6D657263757279222C66696C746572733A227472616E7367656E646572227D2C7B6E616D653A2266612D6E6575746572227D2C7B6E616D653A2266612D7472616E7367656E646572222C66696C746572733A22';
wwv_flow_api.g_varchar2_table(96) := '696E746572736578227D2C7B6E616D653A2266612D7472616E7367656E6465722D616C74227D2C7B6E616D653A2266612D76656E7573222C66696C746572733A2266656D616C65227D2C7B6E616D653A2266612D76656E75732D646F75626C65227D2C7B';
wwv_flow_api.g_varchar2_table(97) := '6E616D653A2266612D76656E75732D6D617273227D5D2C0A202048414E443A5B7B6E616D653A2266612D68616E642D677261622D6F222C66696C746572733A2268616E6420726F636B227D2C7B6E616D653A2266612D68616E642D6C697A6172642D6F22';
wwv_flow_api.g_varchar2_table(98) := '7D2C7B6E616D653A2266612D68616E642D6F2D646F776E222C66696C746572733A22706F696E74227D2C7B6E616D653A2266612D68616E642D6F2D6C656674222C66696C746572733A22706F696E742C6C6566742C70726576696F75732C6261636B227D';
wwv_flow_api.g_varchar2_table(99) := '2C7B6E616D653A2266612D68616E642D6F2D7269676874222C66696C746572733A22706F696E742C72696768742C6E6578742C666F7277617264227D2C7B6E616D653A2266612D68616E642D6F2D7570222C66696C746572733A22706F696E74227D2C7B';
wwv_flow_api.g_varchar2_table(100) := '6E616D653A2266612D68616E642D70656163652D6F227D2C7B6E616D653A2266612D68616E642D706F696E7465722D6F227D2C7B6E616D653A2266612D68616E642D73636973736F72732D6F227D2C7B6E616D653A2266612D68616E642D73706F636B2D';
wwv_flow_api.g_varchar2_table(101) := '6F227D2C7B6E616D653A2266612D68616E642D73746F702D6F222C66696C746572733A2268616E64207061706572227D2C7B6E616D653A2266612D7468756D62732D646F776E222C66696C746572733A226469736C696B652C646973617070726F76652C';
wwv_flow_api.g_varchar2_table(102) := '64697361677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D6F2D646F776E222C66696C746572733A226469736C696B652C646973617070726F76652C64697361677265652C68616E64227D2C7B6E616D653A2266612D7468756D62';
wwv_flow_api.g_varchar2_table(103) := '732D6F2D7570222C66696C746572733A226C696B652C617070726F76652C6661766F726974652C61677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D7570222C66696C746572733A226C696B652C6661766F726974652C61707072';
wwv_flow_api.g_varchar2_table(104) := '6F76652C61677265652C68616E64227D5D2C0A20204D45444943414C3A5B7B6E616D653A2266612D616D62756C616E6365222C66696C746572733A22737570706F72742C68656C70227D2C7B6E616D653A2266612D682D737175617265222C66696C7465';
wwv_flow_api.g_varchar2_table(105) := '72733A22686F73706974616C2C686F74656C227D2C7B6E616D653A2266612D6865617274222C66696C746572733A226C6F76652C6C696B652C6661766F72697465227D2C7B6E616D653A2266612D68656172742D6F222C66696C746572733A226C6F7665';
wwv_flow_api.g_varchar2_table(106) := '2C6C696B652C6661766F72697465227D2C7B6E616D653A2266612D686561727462656174222C66696C746572733A22656B67227D2C7B6E616D653A2266612D686F73706974616C2D6F222C66696C746572733A226275696C64696E67227D2C7B6E616D65';
wwv_flow_api.g_varchar2_table(107) := '3A2266612D6D65646B6974222C66696C746572733A2266697273746169642C66697273746169642C68656C702C737570706F72742C6865616C7468227D2C7B6E616D653A2266612D706C75732D737175617265222C66696C746572733A226164642C6E65';
wwv_flow_api.g_varchar2_table(108) := '772C6372656174652C657870616E64227D2C7B6E616D653A2266612D73746574686F73636F7065227D2C7B6E616D653A2266612D757365722D6D64222C66696C746572733A22646F63746F722C70726F66696C652C6D65646963616C2C6E75727365227D';
wwv_flow_api.g_varchar2_table(109) := '2C7B6E616D653A2266612D776865656C6368616972222C66696C746572733A2268616E64696361702C706572736F6E2C6163636573736962696C6974792C61636365737369626C65227D5D2C0A20204E554D424552533A5B7B6E616D653A2266612D6E75';
wwv_flow_api.g_varchar2_table(110) := '6D6265722D30227D2C7B6E616D653A2266612D6E756D6265722D302D6F227D2C7B6E616D653A2266612D6E756D6265722D31227D2C7B6E616D653A2266612D6E756D6265722D312D6F227D2C7B6E616D653A2266612D6E756D6265722D32227D2C7B6E61';
wwv_flow_api.g_varchar2_table(111) := '6D653A2266612D6E756D6265722D322D6F227D2C7B6E616D653A2266612D6E756D6265722D33227D2C7B6E616D653A2266612D6E756D6265722D332D6F227D2C7B6E616D653A2266612D6E756D6265722D34227D2C7B6E616D653A2266612D6E756D6265';
wwv_flow_api.g_varchar2_table(112) := '722D342D6F227D2C7B6E616D653A2266612D6E756D6265722D35227D2C7B6E616D653A2266612D6E756D6265722D352D6F227D2C7B6E616D653A2266612D6E756D6265722D36227D2C7B6E616D653A2266612D6E756D6265722D362D6F227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(113) := '653A2266612D6E756D6265722D37227D2C7B6E616D653A2266612D6E756D6265722D372D6F227D2C7B6E616D653A2266612D6E756D6265722D38227D2C7B6E616D653A2266612D6E756D6265722D382D6F227D2C7B6E616D653A2266612D6E756D626572';
wwv_flow_api.g_varchar2_table(114) := '2D39227D2C7B6E616D653A2266612D6E756D6265722D392D6F227D5D2C0A20205041594D454E543A5B7B6E616D653A2266612D6372656469742D63617264222C66696C746572733A226D6F6E65792C6275792C64656269742C636865636B6F75742C7075';
wwv_flow_api.g_varchar2_table(115) := '7263686173652C7061796D656E74227D2C7B6E616D653A2266612D6372656469742D636172642D616C74227D2C7B6E616D653A2266612D6372656469742D636172642D7465726D696E616C227D5D2C0A20205350494E4E45523A5B7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(116) := '2D636972636C652D6F2D6E6F746368227D2C7B6E616D653A2266612D67656172222C66696C746572733A2273657474696E67732C636F67227D2C7B6E616D653A2266612D72656672657368222C66696C746572733A2272656C6F61642C73796E63227D2C';
wwv_flow_api.g_varchar2_table(117) := '7B6E616D653A2266612D7370696E6E6572222C66696C746572733A226C6F6164696E672C70726F6772657373227D5D2C0A2020544558545F454449544F523A5B7B6E616D653A2266612D616C69676E2D63656E746572222C66696C746572733A226D6964';
wwv_flow_api.g_varchar2_table(118) := '646C652C74657874227D2C7B6E616D653A2266612D616C69676E2D6A757374696679222C66696C746572733A2274657874227D2C7B6E616D653A2266612D616C69676E2D6C656674222C66696C746572733A2274657874227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(119) := '616C69676E2D7269676874222C66696C746572733A2274657874227D2C7B6E616D653A2266612D626F6C64227D2C7B6E616D653A2266612D636C6970626F617264222C66696C746572733A22636F70792C7061737465227D2C7B6E616D653A2266612D63';
wwv_flow_api.g_varchar2_table(120) := '6C6970626F6172642D6172726F772D646F776E227D2C7B6E616D653A2266612D636C6970626F6172642D6172726F772D7570227D2C7B6E616D653A2266612D636C6970626F6172642D62616E227D2C7B6E616D653A2266612D636C6970626F6172642D62';
wwv_flow_api.g_varchar2_table(121) := '6F6F6B6D61726B227D2C7B6E616D653A2266612D636C6970626F6172642D636861727420227D2C7B6E616D653A2266612D636C6970626F6172642D636865636B227D2C7B6E616D653A2266612D636C6970626F6172642D636865636B2D616C74227D2C7B';
wwv_flow_api.g_varchar2_table(122) := '6E616D653A2266612D636C6970626F6172642D636C6F636B227D2C7B6E616D653A2266612D636C6970626F6172642D65646974227D2C7B6E616D653A2266612D636C6970626F6172642D6865617274227D2C7B6E616D653A2266612D636C6970626F6172';
wwv_flow_api.g_varchar2_table(123) := '642D6C697374227D2C7B6E616D653A2266612D636C6970626F6172642D6C6F636B227D2C7B6E616D653A2266612D636C6970626F6172642D6E6577227D2C7B6E616D653A2266612D636C6970626F6172642D706C7573227D2C7B6E616D653A2266612D63';
wwv_flow_api.g_varchar2_table(124) := '6C6970626F6172642D706F696E746572227D2C7B6E616D653A2266612D636C6970626F6172642D736561726368227D2C7B6E616D653A2266612D636C6970626F6172642D75736572227D2C7B6E616D653A2266612D636C6970626F6172642D7772656E63';
wwv_flow_api.g_varchar2_table(125) := '68227D2C7B6E616D653A2266612D636C6970626F6172642D78227D2C7B6E616D653A2266612D636F6C756D6E73222C66696C746572733A2273706C69742C70616E6573227D2C7B6E616D653A2266612D636F7079222C66696C746572733A226475706C69';
wwv_flow_api.g_varchar2_table(126) := '636174652C636F7079227D2C7B6E616D653A2266612D637574222C66696C746572733A2273636973736F7273227D2C7B6E616D653A2266612D657261736572227D2C7B6E616D653A2266612D66696C65222C66696C746572733A226E65772C706167652C';
wwv_flow_api.g_varchar2_table(127) := '7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D6F222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D74657874222C66696C746572733A226E65772C';
wwv_flow_api.g_varchar2_table(128) := '706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C652D746578742D6F222C66696C746572733A226E65772C706167652C7064662C646F63756D656E74227D2C7B6E616D653A2266612D66696C65732D6F222C66696C7465';
wwv_flow_api.g_varchar2_table(129) := '72733A226475706C69636174652C636F7079227D2C7B6E616D653A2266612D666F6E74222C66696C746572733A2274657874227D2C7B6E616D653A2266612D686561646572222C66696C746572733A2268656164696E67227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(130) := '696E64656E74227D2C7B6E616D653A2266612D6974616C6963222C66696C746572733A226974616C696373227D2C7B6E616D653A2266612D6C696E6B222C66696C746572733A22636861696E227D2C7B6E616D653A2266612D6C697374222C66696C7465';
wwv_flow_api.g_varchar2_table(131) := '72733A22756C2C6F6C2C636865636B6C6973742C66696E69736865642C636F6D706C657465642C646F6E652C746F646F227D2C7B6E616D653A2266612D6C6973742D616C74222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C66696E69';
wwv_flow_api.g_varchar2_table(132) := '736865642C636F6D706C657465642C646F6E652C746F646F227D2C7B6E616D653A2266612D6C6973742D6F6C222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C6C6973742C746F646F2C6C6973742C6E756D62657273227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(133) := '653A2266612D6C6973742D756C222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C746F646F2C6C697374227D2C7B6E616D653A2266612D6F757464656E74222C66696C746572733A22646564656E74227D2C7B6E616D653A2266612D70';
wwv_flow_api.g_varchar2_table(134) := '61706572636C6970222C66696C746572733A226174746163686D656E74227D2C7B6E616D653A2266612D706172616772617068227D2C7B6E616D653A2266612D7061737465222C66696C746572733A22636C6970626F617264227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(135) := '612D726570656174222C66696C746572733A227265646F2C666F72776172642C726F74617465227D2C7B6E616D653A2266612D726F746174652D6C656674222C66696C746572733A226261636B2C756E646F227D2C7B6E616D653A2266612D726F746174';
wwv_flow_api.g_varchar2_table(136) := '652D7269676874222C66696C746572733A227265646F2C666F72776172642C726570656174227D2C7B6E616D653A2266612D73617665222C66696C746572733A22666C6F707079227D2C7B6E616D653A2266612D73636973736F7273222C66696C746572';
wwv_flow_api.g_varchar2_table(137) := '733A22637574227D2C7B6E616D653A2266612D737472696B657468726F756768227D2C7B6E616D653A2266612D737562736372697074227D2C7B6E616D653A2266612D7375706572736372697074222C66696C746572733A226578706F6E656E7469616C';
wwv_flow_api.g_varchar2_table(138) := '227D2C7B6E616D653A2266612D7461626C65222C66696C746572733A22646174612C657863656C2C7370726561647368656574227D2C7B6E616D653A2266612D746578742D686569676874227D2C7B6E616D653A2266612D746578742D7769647468227D';
wwv_flow_api.g_varchar2_table(139) := '2C7B6E616D653A2266612D7468222C66696C746572733A22626C6F636B732C737175617265732C626F7865732C67726964227D2C7B6E616D653A2266612D74682D6C61726765222C66696C746572733A22626C6F636B732C737175617265732C626F7865';
wwv_flow_api.g_varchar2_table(140) := '732C67726964227D2C7B6E616D653A2266612D74682D6C697374222C66696C746572733A22756C2C6F6C2C636865636B6C6973742C66696E69736865642C636F6D706C657465642C646F6E652C746F646F227D2C7B6E616D653A2266612D756E6465726C';
wwv_flow_api.g_varchar2_table(141) := '696E65227D2C7B6E616D653A2266612D756E646F222C66696C746572733A226261636B2C726F74617465227D2C7B6E616D653A2266612D756E6C696E6B222C66696C746572733A2272656D6F76652C636861696E2C62726F6B656E227D5D2C0A20205452';
wwv_flow_api.g_varchar2_table(142) := '414E53504F52544154494F4E3A5B7B6E616D653A2266612D616D62756C616E6365222C66696C746572733A22737570706F72742C68656C70227D2C7B6E616D653A2266612D62696379636C65222C66696C746572733A2276656869636C652C62696B6522';
wwv_flow_api.g_varchar2_table(143) := '7D2C7B6E616D653A2266612D627573222C66696C746572733A2276656869636C65227D2C7B6E616D653A2266612D636172222C66696C746572733A226175746F6D6F62696C652C76656869636C65227D2C7B6E616D653A2266612D666967687465722D6A';
wwv_flow_api.g_varchar2_table(144) := '6574222C66696C746572733A22666C792C706C616E652C616972706C616E652C717569636B2C666173742C74726176656C227D2C7B6E616D653A2266612D6D6F746F726379636C65222C66696C746572733A2276656869636C652C62696B65227D2C7B6E';
wwv_flow_api.g_varchar2_table(145) := '616D653A2266612D706C616E65222C66696C746572733A2274726176656C2C747269702C6C6F636174696F6E2C64657374696E6174696F6E2C616972706C616E652C666C792C6D6F6465227D2C7B6E616D653A2266612D726F636B6574222C66696C7465';
wwv_flow_api.g_varchar2_table(146) := '72733A22617070227D2C7B6E616D653A2266612D73686970222C66696C746572733A22626F61742C736561227D2C7B6E616D653A2266612D73706163652D73687574746C65227D2C7B6E616D653A2266612D737562776179227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(147) := '2D74617869222C66696C746572733A226361622C76656869636C65227D2C7B6E616D653A2266612D747261696E227D2C7B6E616D653A2266612D747275636B222C66696C746572733A227368697070696E67227D2C7B6E616D653A2266612D776865656C';
wwv_flow_api.g_varchar2_table(148) := '6368616972222C66696C746572733A2268616E64696361702C706572736F6E2C6163636573736962696C6974792C61636365737369626C65227D5D2C0A2020564944454F5F504C415945523A5B7B6E616D653A2266612D6172726F77732D616C74222C66';
wwv_flow_api.g_varchar2_table(149) := '696C746572733A22657870616E642C656E6C617267652C66756C6C73637265656E2C6269676765722C6D6F76652C72656F726465722C726573697A65227D2C7B6E616D653A2266612D6261636B77617264222C66696C746572733A22726577696E642C70';
wwv_flow_api.g_varchar2_table(150) := '726576696F7573227D2C7B6E616D653A2266612D636F6D7072657373222C66696C746572733A22636F6C6C617073652C636F6D62696E652C636F6E74726163742C6D657267652C736D616C6C6572227D2C7B6E616D653A2266612D656A656374227D2C7B';
wwv_flow_api.g_varchar2_table(151) := '6E616D653A2266612D657870616E64222C66696C746572733A22656E6C617267652C6269676765722C726573697A65227D2C7B6E616D653A2266612D666173742D6261636B77617264222C66696C746572733A22726577696E642C70726576696F75732C';
wwv_flow_api.g_varchar2_table(152) := '626567696E6E696E672C73746172742C6669727374227D2C7B6E616D653A2266612D666173742D666F7277617264222C66696C746572733A226E6578742C656E642C6C617374227D2C7B6E616D653A2266612D666F7277617264222C66696C746572733A';
wwv_flow_api.g_varchar2_table(153) := '22666F72776172642C6E657874227D2C7B6E616D653A2266612D7061757365222C66696C746572733A2277616974227D2C7B6E616D653A2266612D70617573652D636972636C65227D2C7B6E616D653A2266612D70617573652D636972636C652D6F227D';
wwv_flow_api.g_varchar2_table(154) := '2C7B6E616D653A2266612D706C6179222C66696C746572733A2273746172742C706C6179696E672C6D757369632C736F756E64227D2C7B6E616D653A2266612D706C61792D636972636C65222C66696C746572733A2273746172742C706C6179696E6722';
wwv_flow_api.g_varchar2_table(155) := '7D2C7B6E616D653A2266612D706C61792D636972636C652D6F227D2C7B6E616D653A2266612D72616E646F6D222C66696C746572733A22736F72742C73687566666C65227D2C7B6E616D653A2266612D737465702D6261636B77617264222C66696C7465';
wwv_flow_api.g_varchar2_table(156) := '72733A22726577696E642C70726576696F75732C626567696E6E696E672C73746172742C6669727374227D2C7B6E616D653A2266612D737465702D666F7277617264222C66696C746572733A226E6578742C656E642C6C617374227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(157) := '66612D73746F70222C66696C746572733A22626C6F636B2C626F782C737175617265227D2C7B6E616D653A2266612D73746F702D636972636C65227D2C7B6E616D653A2266612D73746F702D636972636C652D6F227D5D2C0A20205745425F4150504C49';
wwv_flow_api.g_varchar2_table(158) := '434154494F4E3A5B7B6E616D653A2266612D616464726573732D626F6F6B222C66696C746572733A22636F6E7461637473227D2C7B6E616D653A2266612D616464726573732D626F6F6B2D6F222C66696C746572733A22636F6E7461637473227D2C7B6E';
wwv_flow_api.g_varchar2_table(159) := '616D653A2266612D616464726573732D63617264222C66696C746572733A227663617264227D2C7B6E616D653A2266612D616464726573732D636172642D6F222C66696C746572733A2276636172642D6F227D2C7B6E616D653A2266612D61646A757374';
wwv_flow_api.g_varchar2_table(160) := '222C66696C746572733A22636F6E7472617374227D2C7B6E616D653A2266612D616C657274222C66696C746572733A226D6573736167652C636F6D6D656E74227D2C7B6E616D653A2266612D616D65726963616E2D7369676E2D6C616E67756167652D69';
wwv_flow_api.g_varchar2_table(161) := '6E74657270726574696E67227D2C7B6E616D653A2266612D616E63686F72222C66696C746572733A226C696E6B227D2C7B6E616D653A2266612D61706578222C66696C746572733A226170706C69636174696F6E657870726573732C68746D6C64622C77';
wwv_flow_api.g_varchar2_table(162) := '65626462227D2C7B6E616D653A2266612D617065782D737175617265222C66696C746572733A226170706C69636174696F6E657870726573732C68746D6C64622C7765626462227D2C7B6E616D653A2266612D61726368697665222C66696C746572733A';
wwv_flow_api.g_varchar2_table(163) := '22626F782C73746F72616765227D2C7B6E616D653A2266612D617265612D6368617274222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D6172726F7773222C66696C746572733A226D6F76652C72656F72';
wwv_flow_api.g_varchar2_table(164) := '6465722C726573697A65227D2C7B6E616D653A2266612D6172726F77732D68222C66696C746572733A22726573697A65227D2C7B6E616D653A2266612D6172726F77732D76222C66696C746572733A22726573697A65227D2C7B6E616D653A2266612D61';
wwv_flow_api.g_varchar2_table(165) := '736C2D696E74657270726574696E67227D2C7B6E616D653A2266612D6173736973746976652D6C697374656E696E672D73797374656D73227D2C7B6E616D653A2266612D617374657269736B222C66696C746572733A2264657461696C73227D2C7B6E61';
wwv_flow_api.g_varchar2_table(166) := '6D653A2266612D6174227D2C7B6E616D653A2266612D617564696F2D6465736372697074696F6E227D2C7B6E616D653A2266612D62616467652D6C697374227D2C7B6E616D653A2266612D626164676573227D2C7B6E616D653A2266612D62616C616E63';
wwv_flow_api.g_varchar2_table(167) := '652D7363616C65227D2C7B6E616D653A2266612D62616E222C66696C746572733A2264656C6574652C72656D6F76652C74726173682C686964652C626C6F636B2C73746F702C61626F72742C63616E63656C227D2C7B6E616D653A2266612D6261722D63';
wwv_flow_api.g_varchar2_table(168) := '68617274222C66696C746572733A2262617263686172746F2C67726170682C616E616C7974696373227D2C7B6E616D653A2266612D626172636F6465222C66696C746572733A227363616E227D2C7B6E616D653A2266612D62617273222C66696C746572';
wwv_flow_api.g_varchar2_table(169) := '733A226E617669636F6E2C72656F726465722C6D656E752C647261672C72656F726465722C73657474696E67732C6C6973742C756C2C6F6C2C636865636B6C6973742C746F646F2C6C6973742C68616D627572676572227D2C7B6E616D653A2266612D62';
wwv_flow_api.g_varchar2_table(170) := '617468222C66696C746572733A2262617468747562227D2C7B6E616D653A2266612D626174746572792D30222C66696C746572733A22656D707479227D2C7B6E616D653A2266612D626174746572792D31222C66696C746572733A227175617274657222';
wwv_flow_api.g_varchar2_table(171) := '7D2C7B6E616D653A2266612D626174746572792D32222C66696C746572733A2268616C66227D2C7B6E616D653A2266612D626174746572792D33222C66696C746572733A227468726565207175617274657273227D2C7B6E616D653A2266612D62617474';
wwv_flow_api.g_varchar2_table(172) := '6572792D34222C66696C746572733A2266756C6C227D2C7B6E616D653A2266612D626174746C6573686970227D2C7B6E616D653A2266612D626564222C66696C746572733A2274726176656C2C686F74656C227D2C7B6E616D653A2266612D6265657222';
wwv_flow_api.g_varchar2_table(173) := '2C66696C746572733A22616C636F686F6C2C737465696E2C6472696E6B2C6D75672C6261722C6C6971756F72227D2C7B6E616D653A2266612D62656C6C222C66696C746572733A22616C6572742C72656D696E6465722C6E6F74696669636174696F6E22';
wwv_flow_api.g_varchar2_table(174) := '7D2C7B6E616D653A2266612D62656C6C2D6F222C66696C746572733A22616C6572742C72656D696E6465722C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D62656C6C2D736C617368227D2C7B6E616D653A2266612D62656C6C2D736C61';
wwv_flow_api.g_varchar2_table(175) := '73682D6F227D2C7B6E616D653A2266612D62696379636C65222C66696C746572733A2276656869636C652C62696B65227D2C7B6E616D653A2266612D62696E6F63756C617273227D2C7B6E616D653A2266612D62697274686461792D63616B65227D2C7B';
wwv_flow_api.g_varchar2_table(176) := '6E616D653A2266612D626C696E64227D2C7B6E616D653A2266612D626F6C74222C66696C746572733A226C696768746E696E672C776561746865722C666C617368227D2C7B6E616D653A2266612D626F6D62227D2C7B6E616D653A2266612D626F6F6B22';
wwv_flow_api.g_varchar2_table(177) := '2C66696C746572733A22726561642C646F63756D656E746174696F6E227D2C7B6E616D653A2266612D626F6F6B6D61726B222C66696C746572733A2273617665227D2C7B6E616D653A2266612D626F6F6B6D61726B2D6F222C66696C746572733A227361';
wwv_flow_api.g_varchar2_table(178) := '7665227D2C7B6E616D653A2266612D627261696C6C65227D2C7B6E616D653A2266612D62726561646372756D62222C66696C746572733A226E617669676174696F6E227D2C7B6E616D653A2266612D627269656663617365222C66696C746572733A2277';
wwv_flow_api.g_varchar2_table(179) := '6F726B2C627573696E6573732C6F66666963652C6C7567676167652C626167227D2C7B6E616D653A2266612D627567222C66696C746572733A227265706F72742C696E73656374227D2C7B6E616D653A2266612D6275696C64696E67222C66696C746572';
wwv_flow_api.g_varchar2_table(180) := '733A22776F726B2C627573696E6573732C61706172746D656E742C6F66666963652C636F6D70616E79227D2C7B6E616D653A2266612D6275696C64696E672D6F222C66696C746572733A22776F726B2C627573696E6573732C61706172746D656E742C6F';
wwv_flow_api.g_varchar2_table(181) := '66666963652C636F6D70616E79227D2C7B6E616D653A2266612D62756C6C686F726E222C66696C746572733A22616E6E6F756E63656D656E742C73686172652C62726F6164636173742C6C6F75646572227D2C7B6E616D653A2266612D62756C6C736579';
wwv_flow_api.g_varchar2_table(182) := '65222C66696C746572733A22746172676574227D2C7B6E616D653A2266612D627573222C66696C746572733A2276656869636C65227D2C7B6E616D653A2266612D627574746F6E227D2C7B6E616D653A2266612D627574746F6E2D636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(183) := '222C66696C746572733A22726567696F6E227D2C7B6E616D653A2266612D627574746F6E2D67726F7570222C66696C746572733A2270696C6C227D2C7B6E616D653A2266612D63616C63756C61746F72227D2C7B6E616D653A2266612D63616C656E6461';
wwv_flow_api.g_varchar2_table(184) := '72222C66696C746572733A22646174652C74696D652C7768656E227D2C7B6E616D653A2266612D63616C656E6461722D636865636B2D6F227D2C7B6E616D653A2266612D63616C656E6461722D6D696E75732D6F227D2C7B6E616D653A2266612D63616C';
wwv_flow_api.g_varchar2_table(185) := '656E6461722D6F222C66696C746572733A22646174652C74696D652C7768656E227D2C7B6E616D653A2266612D63616C656E6461722D706C75732D6F227D2C7B6E616D653A2266612D63616C656E6461722D74696D65732D6F227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(186) := '612D63616D657261222C66696C746572733A2270686F746F2C706963747572652C7265636F7264227D2C7B6E616D653A2266612D63616D6572612D726574726F222C66696C746572733A2270686F746F2C706963747572652C7265636F7264227D2C7B6E';
wwv_flow_api.g_varchar2_table(187) := '616D653A2266612D636172222C66696C746572733A226175746F6D6F62696C652C76656869636C65227D2C7B6E616D653A2266612D6361726473222C66696C746572733A22626C6F636B73227D2C7B6E616D653A2266612D63617265742D737175617265';
wwv_flow_api.g_varchar2_table(188) := '2D6F2D646F776E222C66696C746572733A22746F67676C65646F776E2C6D6F72652C64726F70646F776E2C6D656E75227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D6C656674222C66696C746572733A2270726576696F75732C62';
wwv_flow_api.g_varchar2_table(189) := '61636B2C746F67676C656C656674227D2C7B6E616D653A2266612D63617265742D7371756172652D6F2D7269676874222C66696C746572733A226E6578742C666F72776172642C746F67676C657269676874227D2C7B6E616D653A2266612D6361726574';
wwv_flow_api.g_varchar2_table(190) := '2D7371756172652D6F2D7570222C66696C746572733A22746F67676C657570227D2C7B6E616D653A2266612D6361726F7573656C222C66696C746572733A22736C69646573686F77227D2C7B6E616D653A2266612D636172742D6172726F772D646F776E';
wwv_flow_api.g_varchar2_table(191) := '222C66696C746572733A2273686F7070696E67227D2C7B6E616D653A2266612D636172742D6172726F772D7570227D2C7B6E616D653A2266612D636172742D636865636B227D2C7B6E616D653A2266612D636172742D65646974222C66696C746572733A';
wwv_flow_api.g_varchar2_table(192) := '2270656E63696C227D2C7B6E616D653A2266612D636172742D656D707479227D2C7B6E616D653A2266612D636172742D66756C6C227D2C7B6E616D653A2266612D636172742D6865617274222C66696C746572733A226C696B652C6661766F7269746522';
wwv_flow_api.g_varchar2_table(193) := '7D2C7B6E616D653A2266612D636172742D6C6F636B227D2C7B6E616D653A2266612D636172742D6D61676E696679696E672D676C617373227D2C7B6E616D653A2266612D636172742D706C7573222C66696C746572733A226164642C73686F7070696E67';
wwv_flow_api.g_varchar2_table(194) := '227D2C7B6E616D653A2266612D636172742D74696D6573227D2C7B6E616D653A2266612D6363227D2C7B6E616D653A2266612D6365727469666963617465222C66696C746572733A2262616467652C73746172227D2C7B6E616D653A2266612D6368616E';
wwv_flow_api.g_varchar2_table(195) := '67652D63617365222C66696C746572733A226C6F776572636173652C757070657263617365227D2C7B6E616D653A2266612D636865636B222C66696C746572733A22636865636B6D61726B2C646F6E652C746F646F2C61677265652C6163636570742C63';
wwv_flow_api.g_varchar2_table(196) := '6F6E6669726D2C7469636B227D2C7B6E616D653A2266612D636865636B2D636972636C65222C66696C746572733A22746F646F2C646F6E652C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D63697263';
wwv_flow_api.g_varchar2_table(197) := '6C652D6F222C66696C746572733A22746F646F2C646F6E652C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D737175617265222C66696C746572733A22636865636B6D61726B2C646F6E652C746F646F';
wwv_flow_api.g_varchar2_table(198) := '2C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266612D636865636B2D7371756172652D6F222C66696C746572733A22746F646F2C646F6E652C61677265652C6163636570742C636F6E6669726D227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(199) := '612D6368696C64227D2C7B6E616D653A2266612D636972636C65222C66696C746572733A22646F742C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D636972636C652D302D38227D2C7B6E616D653A2266612D636972636C652D312D3822';
wwv_flow_api.g_varchar2_table(200) := '7D2C7B6E616D653A2266612D636972636C652D322D38227D2C7B6E616D653A2266612D636972636C652D332D38227D2C7B6E616D653A2266612D636972636C652D342D38227D2C7B6E616D653A2266612D636972636C652D352D38227D2C7B6E616D653A';
wwv_flow_api.g_varchar2_table(201) := '2266612D636972636C652D362D38227D2C7B6E616D653A2266612D636972636C652D372D38227D2C7B6E616D653A2266612D636972636C652D382D38227D2C7B6E616D653A2266612D636972636C652D6F227D2C7B6E616D653A2266612D636972636C65';
wwv_flow_api.g_varchar2_table(202) := '2D6F2D6E6F746368227D2C7B6E616D653A2266612D636972636C652D7468696E227D2C7B6E616D653A2266612D636C6F636B2D6F222C66696C746572733A2277617463682C74696D65722C6C6174652C74696D657374616D70227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(203) := '612D636C6F6E65222C66696C746572733A22636F7079227D2C7B6E616D653A2266612D636C6F7564222C66696C746572733A2273617665227D2C7B6E616D653A2266612D636C6F75642D6172726F772D646F776E227D2C7B6E616D653A2266612D636C6F';
wwv_flow_api.g_varchar2_table(204) := '75642D6172726F772D7570227D2C7B6E616D653A2266612D636C6F75642D62616E227D2C7B6E616D653A2266612D636C6F75642D626F6F6B6D61726B227D2C7B6E616D653A2266612D636C6F75642D6368617274227D2C7B6E616D653A2266612D636C6F';
wwv_flow_api.g_varchar2_table(205) := '75642D636865636B227D2C7B6E616D653A2266612D636C6F75642D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D636C6F75642D637572736F72227D2C7B6E616D653A2266612D636C6F75642D646F776E6C6F';
wwv_flow_api.g_varchar2_table(206) := '6164222C66696C746572733A22696D706F7274227D2C7B6E616D653A2266612D636C6F75642D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D636C6F75642D66696C65227D2C7B6E616D653A2266612D636C6F7564';
wwv_flow_api.g_varchar2_table(207) := '2D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D636C6F75642D6C6F636B227D2C7B6E616D653A2266612D636C6F75642D6E6577227D2C7B6E616D653A2266612D636C6F75642D706C6179227D';
wwv_flow_api.g_varchar2_table(208) := '2C7B6E616D653A2266612D636C6F75642D706C7573227D2C7B6E616D653A2266612D636C6F75642D706F696E746572227D2C7B6E616D653A2266612D636C6F75642D736561726368227D2C7B6E616D653A2266612D636C6F75642D75706C6F6164222C66';
wwv_flow_api.g_varchar2_table(209) := '696C746572733A22696D706F7274227D2C7B6E616D653A2266612D636C6F75642D75736572227D2C7B6E616D653A2266612D636C6F75642D7772656E6368227D2C7B6E616D653A2266612D636C6F75642D78222C66696C746572733A2264656C6574652C';
wwv_flow_api.g_varchar2_table(210) := '72656D6F7665227D2C7B6E616D653A2266612D636F6465222C66696C746572733A2268746D6C2C627261636B657473227D2C7B6E616D653A2266612D636F64652D666F726B222C66696C746572733A226769742C666F726B2C7663732C73766E2C676974';
wwv_flow_api.g_varchar2_table(211) := '6875622C7265626173652C76657273696F6E2C6D65726765227D2C7B6E616D653A2266612D636F64652D67726F7570222C66696C746572733A2267726F75702C6F7665726C6170227D2C7B6E616D653A2266612D636F66666565222C66696C746572733A';
wwv_flow_api.g_varchar2_table(212) := '226D6F726E696E672C6D75672C627265616B666173742C7465612C6472696E6B2C63616665227D2C7B6E616D653A2266612D636F6C6C61707369626C65227D2C7B6E616D653A2266612D636F6D6D656E74222C66696C746572733A227370656563682C6E';
wwv_flow_api.g_varchar2_table(213) := '6F74696669636174696F6E2C6E6F74652C636861742C627562626C652C666565646261636B227D2C7B6E616D653A2266612D636F6D6D656E742D6F222C66696C746572733A226E6F74696669636174696F6E2C6E6F7465227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(214) := '636F6D6D656E74696E67227D2C7B6E616D653A2266612D636F6D6D656E74696E672D6F227D2C7B6E616D653A2266612D636F6D6D656E7473222C66696C746572733A22636F6E766572736174696F6E2C6E6F74696669636174696F6E2C6E6F746573227D';
wwv_flow_api.g_varchar2_table(215) := '2C7B6E616D653A2266612D636F6D6D656E74732D6F222C66696C746572733A22636F6E766572736174696F6E2C6E6F74696669636174696F6E2C6E6F746573227D2C7B6E616D653A2266612D636F6D70617373222C66696C746572733A22736166617269';
wwv_flow_api.g_varchar2_table(216) := '2C6469726563746F72792C6D656E752C6C6F636174696F6E227D2C7B6E616D653A2266612D636F6E7461637473227D2C7B6E616D653A2266612D636F70797269676874227D2C7B6E616D653A2266612D63726561746976652D636F6D6D6F6E73227D2C7B';
wwv_flow_api.g_varchar2_table(217) := '6E616D653A2266612D6372656469742D63617264222C66696C746572733A226D6F6E65792C6275792C64656269742C636865636B6F75742C70757263686173652C7061796D656E74227D2C7B6E616D653A2266612D6372656469742D636172642D616C74';
wwv_flow_api.g_varchar2_table(218) := '227D2C7B6E616D653A2266612D6372656469742D636172642D7465726D696E616C227D2C7B6E616D653A2266612D63726F70227D2C7B6E616D653A2266612D63726F73736861697273222C66696C746572733A227069636B6572227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(219) := '66612D63756265227D2C7B6E616D653A2266612D6375626573227D2C7B6E616D653A2266612D6375746C657279222C66696C746572733A22666F6F642C72657374617572616E742C73706F6F6E2C6B6E6966652C64696E6E65722C656174227D2C7B6E61';
wwv_flow_api.g_varchar2_table(220) := '6D653A2266612D64617368626F617264222C66696C746572733A22746163686F6D65746572227D2C7B6E616D653A2266612D6461746162617365227D2C7B6E616D653A2266612D64617461626173652D6172726F772D646F776E227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(221) := '66612D64617461626173652D6172726F772D7570227D2C7B6E616D653A2266612D64617461626173652D62616E227D2C7B6E616D653A2266612D64617461626173652D626F6F6B6D61726B227D2C7B6E616D653A2266612D64617461626173652D636861';
wwv_flow_api.g_varchar2_table(222) := '7274227D2C7B6E616D653A2266612D64617461626173652D636865636B227D2C7B6E616D653A2266612D64617461626173652D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D64617461626173652D63757273';
wwv_flow_api.g_varchar2_table(223) := '6F72227D2C7B6E616D653A2266612D64617461626173652D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D64617461626173652D66696C65227D2C7B6E616D653A2266612D64617461626173652D6865617274222C';
wwv_flow_api.g_varchar2_table(224) := '66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D64617461626173652D6C6F636B227D2C7B6E616D653A2266612D64617461626173652D6E6577227D2C7B6E616D653A2266612D64617461626173652D706C617922';
wwv_flow_api.g_varchar2_table(225) := '7D2C7B6E616D653A2266612D64617461626173652D706C7573227D2C7B6E616D653A2266612D64617461626173652D706F696E746572227D2C7B6E616D653A2266612D64617461626173652D736561726368227D2C7B6E616D653A2266612D6461746162';
wwv_flow_api.g_varchar2_table(226) := '6173652D75736572227D2C7B6E616D653A2266612D64617461626173652D7772656E6368227D2C7B6E616D653A2266612D64617461626173652D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D64656166';
wwv_flow_api.g_varchar2_table(227) := '227D2C7B6E616D653A2266612D646561666E657373227D2C7B6E616D653A2266612D64657369676E227D2C7B6E616D653A2266612D6465736B746F70222C66696C746572733A226D6F6E69746F722C73637265656E2C6465736B746F702C636F6D707574';
wwv_flow_api.g_varchar2_table(228) := '65722C64656D6F2C646576696365227D2C7B6E616D653A2266612D6469616D6F6E64222C66696C746572733A2267656D2C67656D73746F6E65227D2C7B6E616D653A2266612D646F742D636972636C652D6F222C66696C746572733A227461726765742C';
wwv_flow_api.g_varchar2_table(229) := '62756C6C736579652C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D646F776E6C6F6164222C66696C746572733A22696D706F7274227D2C7B6E616D653A2266612D646F776E6C6F61642D616C74227D2C7B6E616D653A2266612D64796E';
wwv_flow_api.g_varchar2_table(230) := '616D69632D636F6E74656E74227D2C7B6E616D653A2266612D65646974222C66696C746572733A2277726974652C656469742C757064617465227D2C7B6E616D653A2266612D656C6C69707369732D68222C66696C746572733A22646F7473227D2C7B6E';
wwv_flow_api.g_varchar2_table(231) := '616D653A2266612D656C6C69707369732D682D6F227D2C7B6E616D653A2266612D656C6C69707369732D76222C66696C746572733A22646F7473227D2C7B6E616D653A2266612D656C6C69707369732D762D6F227D2C7B6E616D653A2266612D656E7665';
wwv_flow_api.g_varchar2_table(232) := '6C6F7065222C66696C746572733A22656D61696C2C656D61696C2C6C65747465722C737570706F72742C6D61696C2C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D656E76656C6F70652D6172726F772D646F776E227D2C7B6E616D653A';
wwv_flow_api.g_varchar2_table(233) := '2266612D656E76656C6F70652D6172726F772D7570227D2C7B6E616D653A2266612D656E76656C6F70652D62616E227D2C7B6E616D653A2266612D656E76656C6F70652D626F6F6B6D61726B227D2C7B6E616D653A2266612D656E76656C6F70652D6368';
wwv_flow_api.g_varchar2_table(234) := '617274227D2C7B6E616D653A2266612D656E76656C6F70652D636865636B227D2C7B6E616D653A2266612D656E76656C6F70652D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D656E76656C6F70652D637572';
wwv_flow_api.g_varchar2_table(235) := '736F72227D2C7B6E616D653A2266612D656E76656C6F70652D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D656E76656C6F70652D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C';
wwv_flow_api.g_varchar2_table(236) := '7B6E616D653A2266612D656E76656C6F70652D6C6F636B227D2C7B6E616D653A2266612D656E76656C6F70652D6F222C66696C746572733A22656D61696C2C737570706F72742C656D61696C2C6C65747465722C6D61696C2C6E6F74696669636174696F';
wwv_flow_api.g_varchar2_table(237) := '6E227D2C7B6E616D653A2266612D656E76656C6F70652D6F70656E222C66696C746572733A226D61696C227D2C7B6E616D653A2266612D656E76656C6F70652D6F70656E2D6F227D2C7B6E616D653A2266612D656E76656C6F70652D706C6179227D2C7B';
wwv_flow_api.g_varchar2_table(238) := '6E616D653A2266612D656E76656C6F70652D706C7573227D2C7B6E616D653A2266612D656E76656C6F70652D706F696E746572227D2C7B6E616D653A2266612D656E76656C6F70652D736561726368227D2C7B6E616D653A2266612D656E76656C6F7065';
wwv_flow_api.g_varchar2_table(239) := '2D737175617265227D2C7B6E616D653A2266612D656E76656C6F70652D75736572227D2C7B6E616D653A2266612D656E76656C6F70652D7772656E6368227D2C7B6E616D653A2266612D656E76656C6F70652D78222C66696C746572733A2264656C6574';
wwv_flow_api.g_varchar2_table(240) := '652C72656D6F7665227D2C7B6E616D653A2266612D657261736572227D2C7B6E616D653A2266612D657863657074696F6E222C66696C746572733A227761726E696E672C6572726F72227D2C7B6E616D653A2266612D65786368616E6765222C66696C74';
wwv_flow_api.g_varchar2_table(241) := '6572733A227472616E736665722C6172726F7773227D2C7B6E616D653A2266612D6578636C616D6174696F6E222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C6E6F746966792C616C65';
wwv_flow_api.g_varchar2_table(242) := '7274227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D636972636C65222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C657274227D2C7B6E616D653A2266612D657863';
wwv_flow_api.g_varchar2_table(243) := '6C616D6174696F6E2D636972636C652D6F222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C657274227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D6469616D6F6E64';
wwv_flow_api.g_varchar2_table(244) := '222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D6469616D6F6E642D6F222C66696C7465';
wwv_flow_api.g_varchar2_table(245) := '72733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D737175617265222C66696C746572733A227761726E696E';
wwv_flow_api.g_varchar2_table(246) := '672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D7371756172652D6F222C66696C746572733A227761726E696E672C6572726F722C';
wwv_flow_api.g_varchar2_table(247) := '70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D747269616E676C65222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C';
wwv_flow_api.g_varchar2_table(248) := '6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D6578636C616D6174696F6E2D747269616E676C652D6F222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669';
wwv_flow_api.g_varchar2_table(249) := '636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266612D657870616E642D636F6C6C61707365222C66696C746572733A22706C75732C6D696E7573227D2C7B6E616D653A2266612D65787465726E616C2D6C696E6B222C66696C';
wwv_flow_api.g_varchar2_table(250) := '746572733A226F70656E2C6E6577227D2C7B6E616D653A2266612D65787465726E616C2D6C696E6B2D737175617265222C66696C746572733A226F70656E2C6E6577227D2C7B6E616D653A2266612D657965222C66696C746572733A2273686F772C7669';
wwv_flow_api.g_varchar2_table(251) := '7369626C652C7669657773227D2C7B6E616D653A2266612D6579652D736C617368222C66696C746572733A22746F67676C652C73686F772C686964652C76697369626C652C76697369626C6974792C7669657773227D2C7B6E616D653A2266612D657965';
wwv_flow_api.g_varchar2_table(252) := '64726F70706572227D2C7B6E616D653A2266612D666178227D2C7B6E616D653A2266612D66656564222C66696C746572733A22626C6F672C727373227D2C7B6E616D653A2266612D66656D616C65222C66696C746572733A22776F6D616E2C757365722C';
wwv_flow_api.g_varchar2_table(253) := '706572736F6E2C70726F66696C65227D2C7B6E616D653A2266612D666967687465722D6A6574222C66696C746572733A22666C792C706C616E652C616972706C616E652C717569636B2C666173742C74726176656C227D2C7B6E616D653A2266612D6669';
wwv_flow_api.g_varchar2_table(254) := '67687465722D6A65742D616C74222C66696C746572733A22706C616E65227D2C7B6E616D653A2266612D66696C652D617263686976652D6F222C66696C746572733A227A6970227D2C7B6E616D653A2266612D66696C652D6172726F772D646F776E227D';
wwv_flow_api.g_varchar2_table(255) := '2C7B6E616D653A2266612D66696C652D6172726F772D7570227D2C7B6E616D653A2266612D66696C652D617564696F2D6F222C66696C746572733A22736F756E64227D2C7B6E616D653A2266612D66696C652D62616E227D2C7B6E616D653A2266612D66';
wwv_flow_api.g_varchar2_table(256) := '696C652D626F6F6B6D61726B227D2C7B6E616D653A2266612D66696C652D6368617274227D2C7B6E616D653A2266612D66696C652D636865636B227D2C7B6E616D653A2266612D66696C652D636C6F636B222C66696C746572733A22686973746F727922';
wwv_flow_api.g_varchar2_table(257) := '7D2C7B6E616D653A2266612D66696C652D636F64652D6F227D2C7B6E616D653A2266612D66696C652D637572736F72227D2C7B6E616D653A2266612D66696C652D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D66';
wwv_flow_api.g_varchar2_table(258) := '696C652D657863656C2D6F227D2C7B6E616D653A2266612D66696C652D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D66696C652D696D6167652D6F222C66696C746572733A2270686F746F2C';
wwv_flow_api.g_varchar2_table(259) := '70696374757265227D2C7B6E616D653A2266612D66696C652D6C6F636B227D2C7B6E616D653A2266612D66696C652D6E6577227D2C7B6E616D653A2266612D66696C652D7064662D6F227D2C7B6E616D653A2266612D66696C652D706C6179227D2C7B6E';
wwv_flow_api.g_varchar2_table(260) := '616D653A2266612D66696C652D706C7573227D2C7B6E616D653A2266612D66696C652D706F696E746572227D2C7B6E616D653A2266612D66696C652D706F776572706F696E742D6F227D2C7B6E616D653A2266612D66696C652D736561726368227D2C7B';
wwv_flow_api.g_varchar2_table(261) := '6E616D653A2266612D66696C652D73716C227D2C7B6E616D653A2266612D66696C652D75736572227D2C7B6E616D653A2266612D66696C652D766964656F2D6F222C66696C746572733A2266696C656D6F7669656F227D2C7B6E616D653A2266612D6669';
wwv_flow_api.g_varchar2_table(262) := '6C652D776F72642D6F227D2C7B6E616D653A2266612D66696C652D7772656E6368227D2C7B6E616D653A2266612D66696C652D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D653A2266612D66696C6D222C66696C7465';
wwv_flow_api.g_varchar2_table(263) := '72733A226D6F766965227D2C7B6E616D653A2266612D66696C746572222C66696C746572733A2266756E6E656C2C6F7074696F6E73227D2C7B6E616D653A2266612D66697265222C66696C746572733A22666C616D652C686F742C706F70756C6172227D';
wwv_flow_api.g_varchar2_table(264) := '2C7B6E616D653A2266612D666972652D657874696E67756973686572227D2C7B6E616D653A2266612D6669742D746F2D686569676874227D2C7B6E616D653A2266612D6669742D746F2D73697A65227D2C7B6E616D653A2266612D6669742D746F2D7769';
wwv_flow_api.g_varchar2_table(265) := '647468227D2C7B6E616D653A2266612D666C6167222C66696C746572733A227265706F72742C6E6F74696669636174696F6E2C6E6F74696679227D2C7B6E616D653A2266612D666C61672D636865636B65726564222C66696C746572733A227265706F72';
wwv_flow_api.g_varchar2_table(266) := '742C6E6F74696669636174696F6E2C6E6F74696679227D2C7B6E616D653A2266612D666C61672D6F222C66696C746572733A227265706F72742C6E6F74696669636174696F6E227D2C7B6E616D653A2266612D666C6173686C69676874222C66696C7465';
wwv_flow_api.g_varchar2_table(267) := '72733A2266696E642C736561726368227D2C7B6E616D653A2266612D666C61736B222C66696C746572733A22736369656E63652C6265616B65722C6578706572696D656E74616C2C6C616273227D2C7B6E616D653A2266612D666F6C646572227D2C7B6E';
wwv_flow_api.g_varchar2_table(268) := '616D653A2266612D666F6C6465722D6172726F772D646F776E227D2C7B6E616D653A2266612D666F6C6465722D6172726F772D7570227D2C7B6E616D653A2266612D666F6C6465722D62616E227D2C7B6E616D653A2266612D666F6C6465722D626F6F6B';
wwv_flow_api.g_varchar2_table(269) := '6D61726B227D2C7B6E616D653A2266612D666F6C6465722D6368617274227D2C7B6E616D653A2266612D666F6C6465722D636865636B227D2C7B6E616D653A2266612D666F6C6465722D636C6F636B222C66696C746572733A22686973746F7279227D2C';
wwv_flow_api.g_varchar2_table(270) := '7B6E616D653A2266612D666F6C6465722D636C6F7564227D2C7B6E616D653A2266612D666F6C6465722D637572736F72227D2C7B6E616D653A2266612D666F6C6465722D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(271) := '612D666F6C6465722D66696C65227D2C7B6E616D653A2266612D666F6C6465722D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D666F6C6465722D6C6F636B227D2C7B6E616D653A2266612D66';
wwv_flow_api.g_varchar2_table(272) := '6F6C6465722D6E6574776F726B227D2C7B6E616D653A2266612D666F6C6465722D6E6577227D2C7B6E616D653A2266612D666F6C6465722D6F227D2C7B6E616D653A2266612D666F6C6465722D6F70656E227D2C7B6E616D653A2266612D666F6C646572';
wwv_flow_api.g_varchar2_table(273) := '2D6F70656E2D6F227D2C7B6E616D653A2266612D666F6C6465722D706C6179227D2C7B6E616D653A2266612D666F6C6465722D706C7573227D2C7B6E616D653A2266612D666F6C6465722D706F696E746572227D2C7B6E616D653A2266612D666F6C6465';
wwv_flow_api.g_varchar2_table(274) := '722D736561726368227D2C7B6E616D653A2266612D666F6C6465722D75736572227D2C7B6E616D653A2266612D666F6C6465722D7772656E6368227D2C7B6E616D653A2266612D666F6C6465722D78222C66696C746572733A2264656C6574652C72656D';
wwv_flow_api.g_varchar2_table(275) := '6F7665227D2C7B6E616D653A2266612D666F6C64657273227D2C7B6E616D653A2266612D666F6E742D73697A65222C66696C746572733A2274657874227D2C7B6E616D653A2266612D666F6E742D73697A652D6465637265617365222C66696C74657273';
wwv_flow_api.g_varchar2_table(276) := '3A2274657874227D2C7B6E616D653A2266612D666F6E742D73697A652D696E637265617365222C66696C746572733A2274657874227D2C7B6E616D653A2266612D666F726D6174222C66696C746572733A22696E64656E746174696F6E2C636F6465227D';
wwv_flow_api.g_varchar2_table(277) := '2C7B6E616D653A2266612D666F726D73222C66696C746572733A22696E707574227D2C7B6E616D653A2266612D66726F776E2D6F222C66696C746572733A22656D6F7469636F6E2C7361642C646973617070726F76652C726174696E67227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(278) := '653A2266612D66756E6374696F6E222C66696C746572733A22636F6D7075746174696F6E2C70726F6365647572652C6678227D2C7B6E616D653A2266612D667574626F6C2D6F222C66696C746572733A22736F63636572227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(279) := '67616D65706164222C66696C746572733A22636F6E74726F6C6C6572227D2C7B6E616D653A2266612D676176656C222C66696C746572733A226C6567616C227D2C7B6E616D653A2266612D67656172222C66696C746572733A2273657474696E67732C63';
wwv_flow_api.g_varchar2_table(280) := '6F67227D2C7B6E616D653A2266612D6765617273222C66696C746572733A22636F67732C73657474696E6773227D2C7B6E616D653A2266612D67696674222C66696C746572733A2270726573656E74227D2C7B6E616D653A2266612D676C617373222C66';
wwv_flow_api.g_varchar2_table(281) := '696C746572733A226D617274696E692C6472696E6B2C6261722C616C636F686F6C2C6C6971756F72227D2C7B6E616D653A2266612D676C6173736573227D2C7B6E616D653A2266612D676C6F6265222C66696C746572733A22776F726C642C706C616E65';
wwv_flow_api.g_varchar2_table(282) := '742C6D61702C706C6163652C74726176656C2C65617274682C676C6F62616C2C7472616E736C6174652C616C6C2C6C616E67756167652C6C6F63616C697A652C6C6F636174696F6E2C636F6F7264696E617465732C636F756E747279227D2C7B6E616D65';
wwv_flow_api.g_varchar2_table(283) := '3A2266612D67726164756174696F6E2D636170222C66696C746572733A226D6F7274617220626F6172642C6C6561726E696E672C7363686F6F6C2C73747564656E74227D2C7B6E616D653A2266612D68616E642D677261622D6F222C66696C746572733A';
wwv_flow_api.g_varchar2_table(284) := '2268616E6420726F636B227D2C7B6E616D653A2266612D68616E642D6C697A6172642D6F227D2C7B6E616D653A2266612D68616E642D70656163652D6F227D2C7B6E616D653A2266612D68616E642D706F696E7465722D6F227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(285) := '2D68616E642D73636973736F72732D6F227D2C7B6E616D653A2266612D68616E642D73706F636B2D6F227D2C7B6E616D653A2266612D68616E642D73746F702D6F222C66696C746572733A2268616E64207061706572227D2C7B6E616D653A2266612D68';
wwv_flow_api.g_varchar2_table(286) := '616E647368616B652D6F222C66696C746572733A2261677265656D656E74227D2C7B6E616D653A2266612D686172642D6F662D68656172696E67227D2C7B6E616D653A2266612D6861726477617265222C66696C746572733A22636869702C636F6D7075';
wwv_flow_api.g_varchar2_table(287) := '746572227D2C7B6E616D653A2266612D68617368746167227D2C7B6E616D653A2266612D6864642D6F222C66696C746572733A226861726464726976652C6861726464726976652C73746F726167652C73617665227D2C7B6E616D653A2266612D686561';
wwv_flow_api.g_varchar2_table(288) := '6470686F6E6573222C66696C746572733A22736F756E642C6C697374656E2C6D75736963227D2C7B6E616D653A2266612D68656164736574222C66696C746572733A22636861742C737570706F72742C68656C70227D2C7B6E616D653A2266612D686561';
wwv_flow_api.g_varchar2_table(289) := '7274222C66696C746572733A226C6F76652C6C696B652C6661766F72697465227D2C7B6E616D653A2266612D68656172742D6F222C66696C746572733A226C6F76652C6C696B652C6661766F72697465227D2C7B6E616D653A2266612D68656172746265';
wwv_flow_api.g_varchar2_table(290) := '6174222C66696C746572733A22656B67227D2C7B6E616D653A2266612D68656C69636F70746572227D2C7B6E616D653A2266612D6865726F227D2C7B6E616D653A2266612D686973746F7279227D2C7B6E616D653A2266612D686F6D65222C66696C7465';
wwv_flow_api.g_varchar2_table(291) := '72733A226D61696E2C686F757365227D2C7B6E616D653A2266612D686F7572676C617373227D2C7B6E616D653A2266612D686F7572676C6173732D31222C66696C746572733A22686F7572676C6173732D7374617274227D2C7B6E616D653A2266612D68';
wwv_flow_api.g_varchar2_table(292) := '6F7572676C6173732D32222C66696C746572733A22686F7572676C6173732D68616C66227D2C7B6E616D653A2266612D686F7572676C6173732D33222C66696C746572733A22686F7572676C6173732D656E64227D2C7B6E616D653A2266612D686F7572';
wwv_flow_api.g_varchar2_table(293) := '676C6173732D6F227D2C7B6E616D653A2266612D692D637572736F72227D2C7B6E616D653A2266612D69642D6261646765222C66696C746572733A226C616E79617264227D2C7B6E616D653A2266612D69642D63617264222C66696C746572733A226472';
wwv_flow_api.g_varchar2_table(294) := '6976657273206C6963656E73652C206964656E74696669636174696F6E2C206964656E74697479227D2C7B6E616D653A2266612D69642D636172642D6F222C66696C746572733A2264726976657273206C6963656E73652C206964656E74696669636174';
wwv_flow_api.g_varchar2_table(295) := '696F6E2C206964656E74697479227D2C7B6E616D653A2266612D696D616765222C66696C746572733A2270686F746F2C70696374757265227D2C7B6E616D653A2266612D696E626F78227D2C7B6E616D653A2266612D696E646578227D2C7B6E616D653A';
wwv_flow_api.g_varchar2_table(296) := '2266612D696E647573747279227D2C7B6E616D653A2266612D696E666F222C66696C746572733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E616D653A2266612D696E666F2D636972636C65222C66696C7465';
wwv_flow_api.g_varchar2_table(297) := '72733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E616D653A2266612D696E666F2D636972636C652D6F222C66696C746572733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C7322';
wwv_flow_api.g_varchar2_table(298) := '7D2C7B6E616D653A2266612D696E666F2D737175617265222C66696C746572733A2268656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E616D653A2266612D696E666F2D7371756172652D6F222C66696C746572733A22';
wwv_flow_api.g_varchar2_table(299) := '68656C702C696E666F726D6174696F6E2C6D6F72652C64657461696C73227D2C7B6E616D653A2266612D6B6579222C66696C746572733A22756E6C6F636B2C70617373776F7264227D2C7B6E616D653A2266612D6B65792D616C74222C66696C74657273';
wwv_flow_api.g_varchar2_table(300) := '3A226C6F636B2C6B6579227D2C7B6E616D653A2266612D6B6579626F6172642D6F222C66696C746572733A22747970652C696E707574227D2C7B6E616D653A2266612D6C616E6775616765227D2C7B6E616D653A2266612D6C6170746F70222C66696C74';
wwv_flow_api.g_varchar2_table(301) := '6572733A2264656D6F2C636F6D70757465722C646576696365227D2C7B6E616D653A2266612D6C6179657273227D2C7B6E616D653A2266612D6C61796F75742D31636F6C2D32636F6C227D2C7B6E616D653A2266612D6C61796F75742D31636F6C2D3363';
wwv_flow_api.g_varchar2_table(302) := '6F6C227D2C7B6E616D653A2266612D6C61796F75742D31726F772D32726F77227D2C7B6E616D653A2266612D6C61796F75742D32636F6C227D2C7B6E616D653A2266612D6C61796F75742D32636F6C2D31636F6C227D2C7B6E616D653A2266612D6C6179';
wwv_flow_api.g_varchar2_table(303) := '6F75742D32726F77227D2C7B6E616D653A2266612D6C61796F75742D32726F772D31726F77227D2C7B6E616D653A2266612D6C61796F75742D33636F6C227D2C7B6E616D653A2266612D6C61796F75742D33636F6C2D31636F6C227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(304) := '66612D6C61796F75742D33726F77227D2C7B6E616D653A2266612D6C61796F75742D626C616E6B227D2C7B6E616D653A2266612D6C61796F75742D666F6F746572227D2C7B6E616D653A2266612D6C61796F75742D677269642D3378227D2C7B6E616D65';
wwv_flow_api.g_varchar2_table(305) := '3A2266612D6C61796F75742D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D31636F6C2D33636F6C227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D32726F77227D2C7B6E616D653A2266612D6C61';
wwv_flow_api.g_varchar2_table(306) := '796F75742D6865616465722D666F6F746572227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D6E61762D6C6566742D6361726473227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D6E61762D6C6566742D7269676874';
wwv_flow_api.g_varchar2_table(307) := '2D666F6F746572227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D6E61762D72696768742D6361726473227D2C7B6E616D653A2266612D6C61796F75742D6865616465722D736964656261722D6C656674227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(308) := '2D6C61796F75742D6865616465722D736964656261722D7269676874227D2C7B6E616D653A2266612D6C61796F75742D6C6973742D6C656674227D2C7B6E616D653A2266612D6C61796F75742D6C6973742D7269676874227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(309) := '6C61796F75742D6D6F64616C2D626C616E6B227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D636F6C756D6E73227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D677269642D3278227D2C7B6E616D653A2266612D6C6179';
wwv_flow_api.g_varchar2_table(310) := '6F75742D6D6F64616C2D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D6E61762D6C656674227D2C7B6E616D653A2266612D6C61796F75742D6D6F64616C2D6E61762D7269676874227D2C7B6E616D653A2266612D6C61';
wwv_flow_api.g_varchar2_table(311) := '796F75742D6D6F64616C2D726F7773227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C656674227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D6361726473227D2C7B6E616D653A2266612D6C61796F75742D6E6176';
wwv_flow_api.g_varchar2_table(312) := '2D6C6566742D68616D627572676572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D68616D6275726765722D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D6865616465722D63617264';
wwv_flow_api.g_varchar2_table(313) := '73227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D6865616465722D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D6C6566742D7269676874227D2C7B6E616D653A2266612D6C61796F75742D6E6176';
wwv_flow_api.g_varchar2_table(314) := '2D6C6566742D72696768742D6865616465722D666F6F746572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D7269676874227D2C7B6E616D653A2266612D6C61796F75742D6E61762D72696768742D6361726473227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(315) := '612D6C61796F75742D6E61762D72696768742D68616D627572676572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D72696768742D68616D6275726765722D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D7269';
wwv_flow_api.g_varchar2_table(316) := '6768742D686561646572227D2C7B6E616D653A2266612D6C61796F75742D6E61762D72696768742D6865616465722D6361726473227D2C7B6E616D653A2266612D6C61796F75742D736964656261722D6C656674227D2C7B6E616D653A2266612D6C6179';
wwv_flow_api.g_varchar2_table(317) := '6F75742D736964656261722D7269676874227D2C7B6E616D653A2266612D6C61796F7574732D677269642D3278227D2C7B6E616D653A2266612D6C656166222C66696C746572733A2265636F2C6E6174757265227D2C7B6E616D653A2266612D6C656D6F';
wwv_flow_api.g_varchar2_table(318) := '6E2D6F227D2C7B6E616D653A2266612D6C6576656C2D646F776E227D2C7B6E616D653A2266612D6C6576656C2D7570227D2C7B6E616D653A2266612D6C6966652D72696E67222C66696C746572733A226C69666562756F792C6C69666573617665722C73';
wwv_flow_api.g_varchar2_table(319) := '7570706F7274227D2C7B6E616D653A2266612D6C6967687462756C622D6F222C66696C746572733A22696465612C696E737069726174696F6E227D2C7B6E616D653A2266612D6C696E652D6368617274222C66696C746572733A2267726170682C616E61';
wwv_flow_api.g_varchar2_table(320) := '6C7974696373227D2C7B6E616D653A2266612D6C6F636174696F6E2D6172726F77222C66696C746572733A226D61702C636F6F7264696E617465732C6C6F636174696F6E2C616464726573732C706C6163652C7768657265227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(321) := '2D6C6F636B222C66696C746572733A2270726F746563742C61646D696E227D2C7B6E616D653A2266612D6C6F636B2D636865636B227D2C7B6E616D653A2266612D6C6F636B2D66696C65227D2C7B6E616D653A2266612D6C6F636B2D6E6577227D2C7B6E';
wwv_flow_api.g_varchar2_table(322) := '616D653A2266612D6C6F636B2D70617373776F7264227D2C7B6E616D653A2266612D6C6F636B2D706C7573227D2C7B6E616D653A2266612D6C6F636B2D75736572227D2C7B6E616D653A2266612D6C6F636B2D78222C66696C746572733A2264656C6574';
wwv_flow_api.g_varchar2_table(323) := '652C72656D6F7665227D2C7B6E616D653A2266612D6C6F772D766973696F6E227D2C7B6E616D653A2266612D6D61676963222C66696C746572733A2277697A6172642C6175746F6D617469632C6175746F636F6D706C657465227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(324) := '612D6D61676E6574227D2C7B6E616D653A2266612D6D61696C2D666F7277617264222C66696C746572733A226D61696C207368617265227D2C7B6E616D653A2266612D6D616C65222C66696C746572733A226D616E2C757365722C706572736F6E2C7072';
wwv_flow_api.g_varchar2_table(325) := '6F66696C65227D2C7B6E616D653A2266612D6D6170227D2C7B6E616D653A2266612D6D61702D6D61726B6572222C66696C746572733A226D61702C70696E2C6C6F636174696F6E2C636F6F7264696E617465732C6C6F63616C697A652C61646472657373';
wwv_flow_api.g_varchar2_table(326) := '2C74726176656C2C77686572652C706C616365227D2C7B6E616D653A2266612D6D61702D6F227D2C7B6E616D653A2266612D6D61702D70696E227D2C7B6E616D653A2266612D6D61702D7369676E73227D2C7B6E616D653A2266612D6D6174657269616C';
wwv_flow_api.g_varchar2_table(327) := '697A65642D76696577227D2C7B6E616D653A2266612D6D656469612D6C697374227D2C7B6E616D653A2266612D6D65682D6F222C66696C746572733A22656D6F7469636F6E2C726174696E672C6E65757472616C227D2C7B6E616D653A2266612D6D6963';
wwv_flow_api.g_varchar2_table(328) := '726F63686970222C66696C746572733A2273696C69636F6E2C636869702C637075227D2C7B6E616D653A2266612D6D6963726F70686F6E65222C66696C746572733A227265636F72642C766F6963652C736F756E64227D2C7B6E616D653A2266612D6D69';
wwv_flow_api.g_varchar2_table(329) := '63726F70686F6E652D736C617368222C66696C746572733A227265636F72642C766F6963652C736F756E642C6D757465227D2C7B6E616D653A2266612D6D696C69746172792D76656869636C65222C66696C746572733A2268756D7665652C6361722C74';
wwv_flow_api.g_varchar2_table(330) := '7275636B227D2C7B6E616D653A2266612D6D696E7573222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964652C636F6C6C61707365227D2C7B6E616D653A2266612D6D696E75732D636972';
wwv_flow_api.g_varchar2_table(331) := '636C65222C66696C746572733A2264656C6574652C72656D6F76652C74726173682C68696465227D2C7B6E616D653A2266612D6D696E75732D636972636C652D6F222C66696C746572733A2264656C6574652C72656D6F76652C74726173682C68696465';
wwv_flow_api.g_varchar2_table(332) := '227D2C7B6E616D653A2266612D6D696E75732D737175617265222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964652C636F6C6C61707365227D2C7B6E616D653A2266612D6D696E75732D';
wwv_flow_api.g_varchar2_table(333) := '7371756172652D6F222C66696C746572733A22686964652C6D696E6966792C64656C6574652C72656D6F76652C74726173682C686964652C636F6C6C61707365227D2C7B6E616D653A2266612D6D697373696C65227D2C7B6E616D653A2266612D6D6F62';
wwv_flow_api.g_varchar2_table(334) := '696C65222C66696C746572733A2263656C6C70686F6E652C63656C6C70686F6E652C746578742C63616C6C2C6970686F6E652C6E756D6265722C70686F6E65227D2C7B6E616D653A2266612D6D6F6E6579222C66696C746572733A22636173682C6D6F6E';
wwv_flow_api.g_varchar2_table(335) := '65792C6275792C636865636B6F75742C70757263686173652C7061796D656E74227D2C7B6E616D653A2266612D6D6F6F6E2D6F222C66696C746572733A226E696768742C6461726B65722C636F6E7472617374227D2C7B6E616D653A2266612D6D6F746F';
wwv_flow_api.g_varchar2_table(336) := '726379636C65222C66696C746572733A2276656869636C652C62696B65227D2C7B6E616D653A2266612D6D6F7573652D706F696E746572227D2C7B6E616D653A2266612D6D75736963222C66696C746572733A226E6F74652C736F756E64227D2C7B6E61';
wwv_flow_api.g_varchar2_table(337) := '6D653A2266612D6E617669636F6E222C66696C746572733A2272656F726465722C6D656E752C647261672C72656F726465722C73657474696E67732C6C6973742C756C2C6F6C2C636865636B6C6973742C746F646F2C6C6973742C68616D627572676572';
wwv_flow_api.g_varchar2_table(338) := '227D2C7B6E616D653A2266612D6E6574776F726B2D687562227D2C7B6E616D653A2266612D6E6574776F726B2D747269616E676C65227D2C7B6E616D653A2266612D6E65777370617065722D6F222C66696C746572733A227072657373227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(339) := '653A2266612D6E6F7465626F6F6B227D2C7B6E616D653A2266612D6F626A6563742D67726F7570227D2C7B6E616D653A2266612D6F626A6563742D756E67726F7570227D2C7B6E616D653A2266612D6F66666963652D70686F6E65222C66696C74657273';
wwv_flow_api.g_varchar2_table(340) := '3A2270686F6E652C666178227D2C7B6E616D653A2266612D7061636B616765222C66696C746572733A2270726F64756374227D2C7B6E616D653A2266612D7061646C6F636B227D2C7B6E616D653A2266612D7061646C6F636B2D756E6C6F636B227D2C7B';
wwv_flow_api.g_varchar2_table(341) := '6E616D653A2266612D7061696E742D6272757368227D2C7B6E616D653A2266612D70617065722D706C616E65222C66696C746572733A2273656E64227D2C7B6E616D653A2266612D70617065722D706C616E652D6F222C66696C746572733A2273656E64';
wwv_flow_api.g_varchar2_table(342) := '6F227D2C7B6E616D653A2266612D706177222C66696C746572733A22706574227D2C7B6E616D653A2266612D70656E63696C222C66696C746572733A2277726974652C656469742C757064617465227D2C7B6E616D653A2266612D70656E63696C2D7371';
wwv_flow_api.g_varchar2_table(343) := '75617265222C66696C746572733A2277726974652C656469742C757064617465227D2C7B6E616D653A2266612D70656E63696C2D7371756172652D6F222C66696C746572733A2277726974652C656469742C7570646174652C65646974227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(344) := '653A2266612D70657263656E74227D2C7B6E616D653A2266612D70686F6E65222C66696C746572733A2263616C6C2C766F6963652C6E756D6265722C737570706F72742C65617270686F6E65227D2C7B6E616D653A2266612D70686F6E652D7371756172';
wwv_flow_api.g_varchar2_table(345) := '65222C66696C746572733A2263616C6C2C766F6963652C6E756D6265722C737570706F7274227D2C7B6E616D653A2266612D70686F746F222C66696C746572733A22696D6167652C70696374757265227D2C7B6E616D653A2266612D7069652D63686172';
wwv_flow_api.g_varchar2_table(346) := '74222C66696C746572733A2267726170682C616E616C7974696373227D2C7B6E616D653A2266612D706C616E65222C66696C746572733A2274726176656C2C747269702C6C6F636174696F6E2C64657374696E6174696F6E2C616972706C616E652C666C';
wwv_flow_api.g_varchar2_table(347) := '792C6D6F6465227D2C7B6E616D653A2266612D706C7567227D2C7B6E616D653A2266612D706C7573222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706C75732D636972636C65222C6669';
wwv_flow_api.g_varchar2_table(348) := '6C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706C75732D636972636C652D6F222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D70';
wwv_flow_api.g_varchar2_table(349) := '6C75732D737175617265222C66696C746572733A226164642C6E65772C6372656174652C657870616E64227D2C7B6E616D653A2266612D706C75732D7371756172652D6F222C66696C746572733A226164642C6E65772C6372656174652C657870616E64';
wwv_flow_api.g_varchar2_table(350) := '227D2C7B6E616D653A2266612D706F6463617374227D2C7B6E616D653A2266612D706F7765722D6F6666222C66696C746572733A226F6E227D2C7B6E616D653A2266612D707261676D61222C66696C746572733A226E756D6265722C7369676E2C686173';
wwv_flow_api.g_varchar2_table(351) := '682C7368617270227D2C7B6E616D653A2266612D7072696E74227D2C7B6E616D653A2266612D70726F636564757265222C66696C746572733A22636F6D7075746174696F6E2C66756E6374696F6E227D2C7B6E616D653A2266612D70757A7A6C652D7069';
wwv_flow_api.g_varchar2_table(352) := '656365222C66696C746572733A226164646F6E2C6164646F6E2C73656374696F6E227D2C7B6E616D653A2266612D7172636F6465222C66696C746572733A227363616E227D2C7B6E616D653A2266612D7175657374696F6E222C66696C746572733A2268';
wwv_flow_api.g_varchar2_table(353) := '656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D7175657374696F6E2D636972636C65222C66696C746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F';
wwv_flow_api.g_varchar2_table(354) := '7274227D2C7B6E616D653A2266612D7175657374696F6E2D636972636C652D6F222C66696C746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D7175657374696F6E2D737175';
wwv_flow_api.g_varchar2_table(355) := '617265222C66696C746572733A2268656C702C696E666F726D6174696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D7175657374696F6E2D7371756172652D6F222C66696C746572733A2268656C702C696E666F726D6174';
wwv_flow_api.g_varchar2_table(356) := '696F6E2C756E6B6E6F776E2C737570706F7274227D2C7B6E616D653A2266612D71756F74652D6C656674227D2C7B6E616D653A2266612D71756F74652D7269676874227D2C7B6E616D653A2266612D72616E646F6D222C66696C746572733A22736F7274';
wwv_flow_api.g_varchar2_table(357) := '2C73687566666C65227D2C7B6E616D653A2266612D72656379636C65227D2C7B6E616D653A2266612D7265646F2D616C74227D2C7B6E616D653A2266612D7265646F2D6172726F77227D2C7B6E616D653A2266612D72656672657368222C66696C746572';
wwv_flow_api.g_varchar2_table(358) := '733A2272656C6F61642C73796E63227D2C7B6E616D653A2266612D72656769737465726564227D2C7B6E616D653A2266612D72656D6F7665222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D';
wwv_flow_api.g_varchar2_table(359) := '2C7B6E616D653A2266612D7265706C79222C66696C746572733A226D61696C227D2C7B6E616D653A2266612D7265706C792D616C6C222C66696C746572733A226D61696C227D2C7B6E616D653A2266612D72657477656574222C66696C746572733A2272';
wwv_flow_api.g_varchar2_table(360) := '6566726573682C72656C6F61642C7368617265227D2C7B6E616D653A2266612D726F6164222C66696C746572733A22737472656574227D2C7B6E616D653A2266612D726F636B6574222C66696C746572733A22617070227D2C7B6E616D653A2266612D72';
wwv_flow_api.g_varchar2_table(361) := '7373222C66696C746572733A22626C6F672C66656564227D2C7B6E616D653A2266612D7273732D737175617265222C66696C746572733A22666565642C626C6F67227D2C7B6E616D653A2266612D736176652D6173227D2C7B6E616D653A2266612D7365';
wwv_flow_api.g_varchar2_table(362) := '61726368222C66696C746572733A226D61676E6966792C7A6F6F6D2C656E6C617267652C626967676572227D2C7B6E616D653A2266612D7365617263682D6D696E7573222C66696C746572733A226D61676E6966792C6D696E6966792C7A6F6F6D2C736D';
wwv_flow_api.g_varchar2_table(363) := '616C6C6572227D2C7B6E616D653A2266612D7365617263682D706C7573222C66696C746572733A226D61676E6966792C7A6F6F6D2C656E6C617267652C626967676572227D2C7B6E616D653A2266612D73656E64222C66696C746572733A22706C616E65';
wwv_flow_api.g_varchar2_table(364) := '227D2C7B6E616D653A2266612D73656E642D6F222C66696C746572733A22706C616E65227D2C7B6E616D653A2266612D73657175656E6365227D2C7B6E616D653A2266612D736572766572227D2C7B6E616D653A2266612D7365727665722D6172726F77';
wwv_flow_api.g_varchar2_table(365) := '2D646F776E227D2C7B6E616D653A2266612D7365727665722D6172726F772D7570227D2C7B6E616D653A2266612D7365727665722D62616E227D2C7B6E616D653A2266612D7365727665722D626F6F6B6D61726B227D2C7B6E616D653A2266612D736572';
wwv_flow_api.g_varchar2_table(366) := '7665722D6368617274227D2C7B6E616D653A2266612D7365727665722D636865636B227D2C7B6E616D653A2266612D7365727665722D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D7365727665722D656469';
wwv_flow_api.g_varchar2_table(367) := '74227D2C7B6E616D653A2266612D7365727665722D66696C65227D2C7B6E616D653A2266612D7365727665722D6865617274227D2C7B6E616D653A2266612D7365727665722D6C6F636B227D2C7B6E616D653A2266612D7365727665722D6E6577227D2C';
wwv_flow_api.g_varchar2_table(368) := '7B6E616D653A2266612D7365727665722D706C6179227D2C7B6E616D653A2266612D7365727665722D706C7573227D2C7B6E616D653A2266612D7365727665722D706F696E746572227D2C7B6E616D653A2266612D7365727665722D736561726368227D';
wwv_flow_api.g_varchar2_table(369) := '2C7B6E616D653A2266612D7365727665722D75736572227D2C7B6E616D653A2266612D7365727665722D7772656E6368227D2C7B6E616D653A2266612D7365727665722D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(370) := '653A2266612D736861706573222C66696C746572733A227368617265642C636F6D706F6E656E7473227D2C7B6E616D653A2266612D7368617265222C66696C746572733A226D61696C20666F7277617264227D2C7B6E616D653A2266612D73686172652D';
wwv_flow_api.g_varchar2_table(371) := '616C74227D2C7B6E616D653A2266612D73686172652D616C742D737175617265227D2C7B6E616D653A2266612D73686172652D737175617265222C66696C746572733A22736F6369616C2C73656E64227D2C7B6E616D653A2266612D73686172652D7371';
wwv_flow_api.g_varchar2_table(372) := '756172652D6F222C66696C746572733A22736F6369616C2C73656E64227D2C7B6E616D653A2266612D736861726532227D2C7B6E616D653A2266612D736869656C64222C66696C746572733A2261776172642C616368696576656D656E742C77696E6E65';
wwv_flow_api.g_varchar2_table(373) := '72227D2C7B6E616D653A2266612D73686970222C66696C746572733A22626F61742C736561227D2C7B6E616D653A2266612D73686F7070696E672D626167227D2C7B6E616D653A2266612D73686F7070696E672D6261736B6574227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(374) := '66612D73686F7070696E672D63617274222C66696C746572733A22636865636B6F75742C6275792C70757263686173652C7061796D656E74227D2C7B6E616D653A2266612D73686F776572227D2C7B6E616D653A2266612D7369676E2D696E222C66696C';
wwv_flow_api.g_varchar2_table(375) := '746572733A22656E7465722C6A6F696E2C6C6F67696E2C6C6F67696E2C7369676E75702C7369676E696E2C7369676E696E2C7369676E75702C6172726F77227D2C7B6E616D653A2266612D7369676E2D6C616E6775616765227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(376) := '2D7369676E2D6F7574222C66696C746572733A226C6F676F75742C6C6F676F75742C6C656176652C657869742C6172726F77227D2C7B6E616D653A2266612D7369676E616C227D2C7B6E616D653A2266612D7369676E696E67227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(377) := '612D736974656D6170222C66696C746572733A226469726563746F72792C6869657261726368792C6F7267616E697A6174696F6E227D2C7B6E616D653A2266612D736974656D61702D686F72697A6F6E74616C227D2C7B6E616D653A2266612D73697465';
wwv_flow_api.g_varchar2_table(378) := '6D61702D766572746963616C227D2C7B6E616D653A2266612D736C6964657273227D2C7B6E616D653A2266612D736D696C652D6F222C66696C746572733A22656D6F7469636F6E2C68617070792C617070726F76652C7361746973666965642C72617469';
wwv_flow_api.g_varchar2_table(379) := '6E67227D2C7B6E616D653A2266612D736E6F77666C616B65222C66696C746572733A2266726F7A656E227D2C7B6E616D653A2266612D736F636365722D62616C6C2D6F222C66696C746572733A22666F6F7462616C6C227D2C7B6E616D653A2266612D73';
wwv_flow_api.g_varchar2_table(380) := '6F7274222C66696C746572733A226F726465722C756E736F72746564227D2C7B6E616D653A2266612D736F72742D616C7068612D617363227D2C7B6E616D653A2266612D736F72742D616C7068612D64657363227D2C7B6E616D653A2266612D736F7274';
wwv_flow_api.g_varchar2_table(381) := '2D616D6F756E742D617363227D2C7B6E616D653A2266612D736F72742D616D6F756E742D64657363227D2C7B6E616D653A2266612D736F72742D617363222C66696C746572733A227570227D2C7B6E616D653A2266612D736F72742D64657363222C6669';
wwv_flow_api.g_varchar2_table(382) := '6C746572733A2264726F70646F776E2C6D6F72652C6D656E752C646F776E227D2C7B6E616D653A2266612D736F72742D6E756D657269632D617363222C66696C746572733A226E756D62657273227D2C7B6E616D653A2266612D736F72742D6E756D6572';
wwv_flow_api.g_varchar2_table(383) := '69632D64657363222C66696C746572733A226E756D62657273227D2C7B6E616D653A2266612D73706163652D73687574746C65227D2C7B6E616D653A2266612D7370696E6E6572222C66696C746572733A226C6F6164696E672C70726F6772657373227D';
wwv_flow_api.g_varchar2_table(384) := '2C7B6E616D653A2266612D73706F6F6E227D2C7B6E616D653A2266612D737175617265222C66696C746572733A22626C6F636B2C626F78227D2C7B6E616D653A2266612D7371756172652D6F222C66696C746572733A22626C6F636B2C7371756172652C';
wwv_flow_api.g_varchar2_table(385) := '626F78227D2C7B6E616D653A2266612D7371756172652D73656C65637465642D6F222C66696C746572733A22626C6F636B2C7371756172652C626F78227D2C7B6E616D653A2266612D73746172222C66696C746572733A2261776172642C616368696576';
wwv_flow_api.g_varchar2_table(386) := '656D656E742C6E696768742C726174696E672C73636F7265227D2C7B6E616D653A2266612D737461722D68616C66222C66696C746572733A2261776172642C616368696576656D656E742C726174696E672C73636F7265227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(387) := '737461722D68616C662D6F222C66696C746572733A2261776172642C616368696576656D656E742C726174696E672C73636F72652C68616C66227D2C7B6E616D653A2266612D737461722D6F222C66696C746572733A2261776172642C61636869657665';
wwv_flow_api.g_varchar2_table(388) := '6D656E742C6E696768742C726174696E672C73636F7265227D2C7B6E616D653A2266612D737469636B792D6E6F7465227D2C7B6E616D653A2266612D737469636B792D6E6F74652D6F227D2C7B6E616D653A2266612D7374726565742D76696577222C66';
wwv_flow_api.g_varchar2_table(389) := '696C746572733A226D6170227D2C7B6E616D653A2266612D7375697463617365222C66696C746572733A22747269702C6C7567676167652C74726176656C2C6D6F76652C62616767616765227D2C7B6E616D653A2266612D73756E2D6F222C66696C7465';
wwv_flow_api.g_varchar2_table(390) := '72733A22776561746865722C636F6E74726173742C6C6967687465722C627269676874656E2C646179227D2C7B6E616D653A2266612D737570706F7274222C66696C746572733A226C69666562756F792C6C69666573617665722C6C69666572696E6722';
wwv_flow_api.g_varchar2_table(391) := '7D2C7B6E616D653A2266612D73796E6F6E796D222C66696C746572733A22636F70792C6475706C6963617465227D2C7B6E616D653A2266612D7461626C652D6172726F772D646F776E227D2C7B6E616D653A2266612D7461626C652D6172726F772D7570';
wwv_flow_api.g_varchar2_table(392) := '227D2C7B6E616D653A2266612D7461626C652D62616E227D2C7B6E616D653A2266612D7461626C652D626F6F6B6D61726B227D2C7B6E616D653A2266612D7461626C652D6368617274227D2C7B6E616D653A2266612D7461626C652D636865636B227D2C';
wwv_flow_api.g_varchar2_table(393) := '7B6E616D653A2266612D7461626C652D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D7461626C652D637572736F72227D2C7B6E616D653A2266612D7461626C652D65646974222C66696C746572733A227065';
wwv_flow_api.g_varchar2_table(394) := '6E63696C227D2C7B6E616D653A2266612D7461626C652D66696C65227D2C7B6E616D653A2266612D7461626C652D6865617274222C66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D7461626C652D6C6F636B227D';
wwv_flow_api.g_varchar2_table(395) := '2C7B6E616D653A2266612D7461626C652D6E6577227D2C7B6E616D653A2266612D7461626C652D706C6179227D2C7B6E616D653A2266612D7461626C652D706C7573227D2C7B6E616D653A2266612D7461626C652D706F696E746572227D2C7B6E616D65';
wwv_flow_api.g_varchar2_table(396) := '3A2266612D7461626C652D736561726368227D2C7B6E616D653A2266612D7461626C652D75736572227D2C7B6E616D653A2266612D7461626C652D7772656E6368227D2C7B6E616D653A2266612D7461626C652D78222C66696C746572733A2264656C65';
wwv_flow_api.g_varchar2_table(397) := '74652C72656D6F7665227D2C7B6E616D653A2266612D7461626C6574222C66696C746572733A22697061642C646576696365227D2C7B6E616D653A2266612D74616273227D2C7B6E616D653A2266612D746163686F6D65746572222C66696C746572733A';
wwv_flow_api.g_varchar2_table(398) := '2264617368626F617264227D2C7B6E616D653A2266612D746167222C66696C746572733A226C6162656C227D2C7B6E616D653A2266612D74616773222C66696C746572733A226C6162656C73227D2C7B6E616D653A2266612D74616E6B227D2C7B6E616D';
wwv_flow_api.g_varchar2_table(399) := '653A2266612D7461736B73222C66696C746572733A2270726F67726573732C6C6F6164696E672C646F776E6C6F6164696E672C646F776E6C6F6164732C73657474696E6773227D2C7B6E616D653A2266612D74617869222C66696C746572733A22636162';
wwv_flow_api.g_varchar2_table(400) := '2C76656869636C65227D2C7B6E616D653A2266612D74656C65766973696F6E222C66696C746572733A227476227D2C7B6E616D653A2266612D7465726D696E616C222C66696C746572733A22636F6D6D616E642C70726F6D70742C636F6465227D2C7B6E';
wwv_flow_api.g_varchar2_table(401) := '616D653A2266612D746865726D6F6D657465722D30222C66696C746572733A22746865726D6F6D657465722D656D707479227D2C7B6E616D653A2266612D746865726D6F6D657465722D31222C66696C746572733A22746865726D6F6D657465722D7175';
wwv_flow_api.g_varchar2_table(402) := '6172746572227D2C7B6E616D653A2266612D746865726D6F6D657465722D32222C66696C746572733A22746865726D6F6D657465722D68616C66227D2C7B6E616D653A2266612D746865726D6F6D657465722D33222C66696C746572733A22746865726D';
wwv_flow_api.g_varchar2_table(403) := '6F6D657465722D74687265652D7175617274657273227D2C7B6E616D653A2266612D746865726D6F6D657465722D34222C66696C746572733A22746865726D6F6D657465722D66756C6C2C746865726D6F6D65746572227D2C7B6E616D653A2266612D74';
wwv_flow_api.g_varchar2_table(404) := '68756D622D7461636B222C66696C746572733A226D61726B65722C70696E2C6C6F636174696F6E2C636F6F7264696E61746573227D2C7B6E616D653A2266612D7468756D62732D646F776E222C66696C746572733A226469736C696B652C646973617070';
wwv_flow_api.g_varchar2_table(405) := '726F76652C64697361677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D6F2D646F776E222C66696C746572733A226469736C696B652C646973617070726F76652C64697361677265652C68616E64227D2C7B6E616D653A2266612D';
wwv_flow_api.g_varchar2_table(406) := '7468756D62732D6F2D7570222C66696C746572733A226C696B652C617070726F76652C6661766F726974652C61677265652C68616E64227D2C7B6E616D653A2266612D7468756D62732D7570222C66696C746572733A226C696B652C6661766F72697465';
wwv_flow_api.g_varchar2_table(407) := '2C617070726F76652C61677265652C68616E64227D2C7B6E616D653A2266612D7469636B6574222C66696C746572733A226D6F7669652C706173732C737570706F7274227D2C7B6E616D653A2266612D74696C65732D327832227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(408) := '612D74696C65732D337833227D2C7B6E616D653A2266612D74696C65732D38227D2C7B6E616D653A2266612D74696C65732D39227D2C7B6E616D653A2266612D74696D6573222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C65';
wwv_flow_api.g_varchar2_table(409) := '7869742C782C63726F7373227D2C7B6E616D653A2266612D74696D65732D636972636C65222C66696C746572733A22636C6F73652C657869742C78227D2C7B6E616D653A2266612D74696D65732D636972636C652D6F222C66696C746572733A22636C6F';
wwv_flow_api.g_varchar2_table(410) := '73652C657869742C78227D2C7B6E616D653A2266612D74696D65732D72656374616E676C65222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D74696D65732D7265';
wwv_flow_api.g_varchar2_table(411) := '6374616E676C652D6F222C66696C746572733A2272656D6F76652C636C6F73652C636C6F73652C657869742C782C63726F7373227D2C7B6E616D653A2266612D74696E74222C66696C746572733A227261696E64726F702C776174657264726F702C6472';
wwv_flow_api.g_varchar2_table(412) := '6F702C64726F706C6574227D2C7B6E616D653A2266612D746F67676C652D6F6666227D2C7B6E616D653A2266612D746F67676C652D6F6E227D2C7B6E616D653A2266612D746F6F6C73222C66696C746572733A2273637265776472697665722C7772656E';
wwv_flow_api.g_varchar2_table(413) := '6368227D2C7B6E616D653A2266612D74726164656D61726B227D2C7B6E616D653A2266612D7472617368222C66696C746572733A22676172626167652C64656C6574652C72656D6F76652C68696465227D2C7B6E616D653A2266612D74726173682D6F22';
wwv_flow_api.g_varchar2_table(414) := '2C66696C746572733A22676172626167652C64656C6574652C72656D6F76652C74726173682C68696465227D2C7B6E616D653A2266612D74726565227D2C7B6E616D653A2266612D747265652D6F7267227D2C7B6E616D653A2266612D74726967676572';
wwv_flow_api.g_varchar2_table(415) := '227D2C7B6E616D653A2266612D74726F706879222C66696C746572733A2261776172642C616368696576656D656E742C77696E6E65722C67616D65227D2C7B6E616D653A2266612D747275636B222C66696C746572733A227368697070696E67227D2C7B';
wwv_flow_api.g_varchar2_table(416) := '6E616D653A2266612D747479227D2C7B6E616D653A2266612D756D6272656C6C61227D2C7B6E616D653A2266612D756E646F2D616C74227D2C7B6E616D653A2266612D756E646F2D6172726F77227D2C7B6E616D653A2266612D756E6976657273616C2D';
wwv_flow_api.g_varchar2_table(417) := '616363657373227D2C7B6E616D653A2266612D756E6976657273697479222C66696C746572733A22696E737469747574696F6E2C62616E6B227D2C7B6E616D653A2266612D756E6C6F636B222C66696C746572733A2270726F746563742C61646D696E2C';
wwv_flow_api.g_varchar2_table(418) := '70617373776F72642C6C6F636B227D2C7B6E616D653A2266612D756E6C6F636B2D616C74222C66696C746572733A2270726F746563742C61646D696E2C70617373776F72642C6C6F636B227D2C7B6E616D653A2266612D75706C6F6164222C66696C7465';
wwv_flow_api.g_varchar2_table(419) := '72733A22696D706F7274227D2C7B6E616D653A2266612D75706C6F61642D616C74227D2C7B6E616D653A2266612D75736572222C66696C746572733A22706572736F6E2C6D616E2C686561642C70726F66696C65227D2C7B6E616D653A2266612D757365';
wwv_flow_api.g_varchar2_table(420) := '722D6172726F772D646F776E227D2C7B6E616D653A2266612D757365722D6172726F772D7570227D2C7B6E616D653A2266612D757365722D62616E227D2C7B6E616D653A2266612D757365722D6368617274227D2C7B6E616D653A2266612D757365722D';
wwv_flow_api.g_varchar2_table(421) := '636865636B227D2C7B6E616D653A2266612D757365722D636972636C65227D2C7B6E616D653A2266612D757365722D636972636C652D6F227D2C7B6E616D653A2266612D757365722D636C6F636B222C66696C746572733A22686973746F7279227D2C7B';
wwv_flow_api.g_varchar2_table(422) := '6E616D653A2266612D757365722D637572736F72227D2C7B6E616D653A2266612D757365722D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D757365722D6772616475617465227D2C7B6E616D653A2266612D7573';
wwv_flow_api.g_varchar2_table(423) := '65722D68656164736574227D2C7B6E616D653A2266612D757365722D6865617274222C66696C746572733A226C696B652C6661766F726974652C6C6F7665227D2C7B6E616D653A2266612D757365722D6C6F636B227D2C7B6E616D653A2266612D757365';
wwv_flow_api.g_varchar2_table(424) := '722D6D61676E696679696E672D676C617373227D2C7B6E616D653A2266612D757365722D6D616E227D2C7B6E616D653A2266612D757365722D706C6179227D2C7B6E616D653A2266612D757365722D706C7573222C66696C746572733A227369676E7570';
wwv_flow_api.g_varchar2_table(425) := '2C7369676E7570227D2C7B6E616D653A2266612D757365722D706F696E746572227D2C7B6E616D653A2266612D757365722D736563726574222C66696C746572733A22776869737065722C7370792C696E636F676E69746F227D2C7B6E616D653A226661';
wwv_flow_api.g_varchar2_table(426) := '2D757365722D776F6D616E227D2C7B6E616D653A2266612D757365722D7772656E6368227D2C7B6E616D653A2266612D757365722D78227D2C7B6E616D653A2266612D7573657273222C66696C746572733A2270656F706C652C70726F66696C65732C70';
wwv_flow_api.g_varchar2_table(427) := '6572736F6E732C67726F7570227D2C7B6E616D653A2266612D75736572732D63686174227D2C7B6E616D653A2266612D7661726961626C65227D2C7B6E616D653A2266612D766964656F2D63616D657261222C66696C746572733A2266696C6D2C6D6F76';
wwv_flow_api.g_varchar2_table(428) := '69652C7265636F7264227D2C7B6E616D653A2266612D766F6C756D652D636F6E74726F6C2D70686F6E65227D2C7B6E616D653A2266612D766F6C756D652D646F776E222C66696C746572733A226C6F7765722C717569657465722C736F756E642C6D7573';
wwv_flow_api.g_varchar2_table(429) := '6963227D2C7B6E616D653A2266612D766F6C756D652D6F6666222C66696C746572733A226D7574652C736F756E642C6D75736963227D2C7B6E616D653A2266612D766F6C756D652D7570222C66696C746572733A226869676865722C6C6F756465722C73';
wwv_flow_api.g_varchar2_table(430) := '6F756E642C6D75736963227D2C7B6E616D653A2266612D7761726E696E67222C66696C746572733A227761726E696E672C6572726F722C70726F626C656D2C6E6F74696669636174696F6E2C616C6572742C7761726E696E67227D2C7B6E616D653A2266';
wwv_flow_api.g_varchar2_table(431) := '612D776865656C6368616972222C66696C746572733A2268616E64696361702C706572736F6E2C6163636573736962696C6974792C61636365737369626C65227D2C7B6E616D653A2266612D776865656C63686169722D616C74227D2C7B6E616D653A22';
wwv_flow_api.g_varchar2_table(432) := '66612D77696669227D2C7B6E616D653A2266612D77696E646F77227D2C7B6E616D653A2266612D77696E646F772D616C74227D2C7B6E616D653A2266612D77696E646F772D616C742D32227D2C7B6E616D653A2266612D77696E646F772D6172726F772D';
wwv_flow_api.g_varchar2_table(433) := '646F776E227D2C7B6E616D653A2266612D77696E646F772D6172726F772D7570227D2C7B6E616D653A2266612D77696E646F772D62616E227D2C7B6E616D653A2266612D77696E646F772D626F6F6B6D61726B227D2C7B6E616D653A2266612D77696E64';
wwv_flow_api.g_varchar2_table(434) := '6F772D6368617274227D2C7B6E616D653A2266612D77696E646F772D636865636B227D2C7B6E616D653A2266612D77696E646F772D636C6F636B222C66696C746572733A22686973746F7279227D2C7B6E616D653A2266612D77696E646F772D636C6F73';
wwv_flow_api.g_varchar2_table(435) := '65222C66696C746572733A2274696D65732C2072656374616E676C65227D2C7B6E616D653A2266612D77696E646F772D636C6F73652D6F222C66696C746572733A2274696D65732C2072656374616E676C65227D2C7B6E616D653A2266612D77696E646F';
wwv_flow_api.g_varchar2_table(436) := '772D637572736F72227D2C7B6E616D653A2266612D77696E646F772D65646974222C66696C746572733A2270656E63696C227D2C7B6E616D653A2266612D77696E646F772D66696C65227D2C7B6E616D653A2266612D77696E646F772D6865617274222C';
wwv_flow_api.g_varchar2_table(437) := '66696C746572733A226C696B652C6661766F72697465227D2C7B6E616D653A2266612D77696E646F772D6C6F636B227D2C7B6E616D653A2266612D77696E646F772D6D6178696D697A65227D2C7B6E616D653A2266612D77696E646F772D6D696E696D69';
wwv_flow_api.g_varchar2_table(438) := '7A65227D2C7B6E616D653A2266612D77696E646F772D6E6577227D2C7B6E616D653A2266612D77696E646F772D706C6179227D2C7B6E616D653A2266612D77696E646F772D706C7573227D2C7B6E616D653A2266612D77696E646F772D706F696E746572';
wwv_flow_api.g_varchar2_table(439) := '227D2C7B6E616D653A2266612D77696E646F772D726573746F7265227D2C7B6E616D653A2266612D77696E646F772D736561726368227D2C7B6E616D653A2266612D77696E646F772D7465726D696E616C222C66696C746572733A22636F6E736F6C6522';
wwv_flow_api.g_varchar2_table(440) := '7D2C7B6E616D653A2266612D77696E646F772D75736572227D2C7B6E616D653A2266612D77696E646F772D7772656E6368227D2C7B6E616D653A2266612D77696E646F772D78222C66696C746572733A2264656C6574652C72656D6F7665227D2C7B6E61';
wwv_flow_api.g_varchar2_table(441) := '6D653A2266612D77697A617264222C66696C746572733A2273746570732C70726F6772657373227D2C7B6E616D653A2266612D7772656E6368222C66696C746572733A2273657474696E67732C6669782C757064617465227D5D0A7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(18528126332786575)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_file_name=>'IPicons.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '402D6D732D76696577706F7274207B0A202077696474683A206465766963652D77696474683B0A7D0A0A402D6F2D76696577706F7274207B0A202077696474683A206465766963652D77696474683B0A7D0A0A4076696577706F7274207B0A2020776964';
wwv_flow_api.g_varchar2_table(2) := '74683A206465766963652D77696474683B0A7D0A0A68746D6C207B0A2020626F782D73697A696E673A20626F726465722D626F783B0A7D0A0A2A2C0A2A203A3A6265666F72652C0A2A203A3A6166746572207B0A2020626F782D73697A696E673A20696E';
wwv_flow_api.g_varchar2_table(3) := '68657269743B0A7D0A0A68746D6C207B0A20202D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0A20202D6D732D6F766572666C6F772D7374796C653A207363726F6C6C6261723B0A20202D7765626B69742D74';
wwv_flow_api.g_varchar2_table(4) := '61702D686967686C696768742D636F6C6F723A207472616E73706172656E743B0A20202D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A20677261797363616C653B0A7D0A0A626F6479207B0A2020646973706C61793A20666C65783B0A2020';
wwv_flow_api.g_varchar2_table(5) := '666C65782D646972656374696F6E3A20636F6C756D6E3B0A20206D617267696E3A20303B0A202070616464696E673A20303B0A20206D696E2D77696474683A2033323070783B0A20206D696E2D6865696768743A20313030253B0A20206D696E2D686569';
wwv_flow_api.g_varchar2_table(6) := '6768743A2031303076683B0A2020666F6E742D73697A653A20313670783B0A2020666F6E742D66616D696C793A202D6170706C652D73797374656D2C20426C696E6B4D616353797374656D466F6E742C20225365676F65205549222C2022526F626F746F';
wwv_flow_api.g_varchar2_table(7) := '222C20224F787967656E222C20225562756E7475222C202243616E746172656C6C222C2022466972612053616E73222C202244726F69642053616E73222C202248656C766574696361204E657565222C2073616E732D73657269663B0A20206C696E652D';
wwv_flow_api.g_varchar2_table(8) := '6865696768743A20312E353B0A20206261636B67726F756E642D636F6C6F723A20236637663766373B0A7D0A0A61207B0A2020746578742D6465636F726174696F6E3A206E6F6E653B0A2020636F6C6F723A20233035373243453B0A7D0A0A613A6E6F74';
wwv_flow_api.g_varchar2_table(9) := '285B636C6173735D293A686F766572207B0A2020746578742D6465636F726174696F6E3A20756E6465726C696E653B0A7D0A0A70207B0A20206D617267696E3A2030203020323470783B0A7D0A0A703A6C6173742D6368696C64207B0A20206D61726769';
wwv_flow_api.g_varchar2_table(10) := '6E2D626F74746F6D3A20303B0A7D0A0A6831207B0A20206D617267696E3A2030203020313670783B0A2020666F6E742D73697A653A20343870783B0A7D0A0A6832207B0A20206D617267696E3A2030203020313270783B0A2020666F6E742D73697A653A';
wwv_flow_api.g_varchar2_table(11) := '20333270783B0A7D0A0A6833207B0A20206D617267696E3A20302030203870783B0A2020666F6E742D73697A653A20323470783B0A7D0A0A6834207B0A20206D617267696E2D626F74746F6D3A203470783B0A2020666F6E742D73697A653A2032307078';
wwv_flow_api.g_varchar2_table(12) := '3B0A7D0A0A0A636F64652C0A707265207B0A2020666F6E742D73697A653A203930253B0A2020666F6E742D66616D696C793A2053464D6F6E6F2D526567756C61722C204D656E6C6F2C204D6F6E61636F2C20436F6E736F6C61732C20224C696265726174';
wwv_flow_api.g_varchar2_table(13) := '696F6E204D6F6E6F222C2022436F7572696572204E6577222C206D6F6E6F73706163653B0A20206261636B67726F756E642D636F6C6F723A207267626128302C302C302C2E303235293B0A2020626F782D736861646F773A20696E736574207267626128';
wwv_flow_api.g_varchar2_table(14) := '302C302C302C2E303529203020302030203170783B0A7D0A0A636F6465207B0A202070616464696E673A20327078203470783B0A2020626F726465722D7261646975733A203270783B0A7D0A0A707265207B0A202070616464696E673A203870783B0A20';
wwv_flow_api.g_varchar2_table(15) := '20626F726465722D7261646975733A203470783B0A20206D617267696E2D626F74746F6D3A20313670783B0A7D0A0A2E69636F6E2D636C617373207B0A2020636F6C6F723A20233137373536633B0A7D0A2E6D6F6469666965722D636C617373207B0A20';
wwv_flow_api.g_varchar2_table(16) := '20636F6C6F723A20233963323762300A7D0A0A0A2E646D2D41636365737369626C6548696464656E207B0A2020706F736974696F6E3A206162736F6C7574653B0A20206C6566743A202D313030303070783B0A2020746F703A206175746F3B0A20207769';
wwv_flow_api.g_varchar2_table(17) := '6474683A203170783B0A20206865696768743A203170783B0A20206F766572666C6F773A2068696464656E3B0A7D0A0A0A0A2E646D2D486561646572207B0A2020636F6C6F723A20236666663B0A20206261636B67726F756E642D636F6C6F723A202330';
wwv_flow_api.g_varchar2_table(18) := '35373243453B0A2020666C65782D67726F773A20303B0A7D0A0A2E646D2D486561646572203E202E646D2D436F6E7461696E6572207B0A2020646973706C61793A20666C65783B0A202070616464696E672D746F703A20313670783B0A20207061646469';
wwv_flow_api.g_varchar2_table(19) := '6E672D626F74746F6D3A20313670783B0A7D0A0A406D656469612073637265656E20616E6420286D61782D77696474683A20373637707829207B0A20202E646D2D486561646572203E202E646D2D436F6E7461696E6572207B0A2020202070616464696E';
wwv_flow_api.g_varchar2_table(20) := '672D746F703A203470783B0A2020202070616464696E672D626F74746F6D3A203470783B0A20207D0A7D0A0A2E646D2D4865616465722D6C6F676F4C696E6B207B0A2020646973706C61793A20696E6C696E652D666C65783B0A2020766572746963616C';
wwv_flow_api.g_varchar2_table(21) := '2D616C69676E3A20746F703B0A2020746578742D6465636F726174696F6E3A206E6F6E653B0A2020636F6C6F723A20236666663B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A2E646D2D4865616465722D6C6F676F49636F6E207B0A';
wwv_flow_api.g_varchar2_table(22) := '2020646973706C61793A20626C6F636B3B0A20206D617267696E2D72696768743A203470783B0A202077696474683A2031323870783B0A20206865696768743A20343870783B0A202066696C6C3A2063757272656E74436F6C6F723B0A20202D6D732D67';
wwv_flow_api.g_varchar2_table(23) := '7269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A2E646D2D4865616465722D6C6F676F4C6162656C207B0A2020666F6E742D7765696768743A203530303B0A2020666F6E742D7369';
wwv_flow_api.g_varchar2_table(24) := '7A653A20313470783B0A20202D6D732D677269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A406D656469612073637265656E20616E6420286D696E2D77696474683A203336307078';
wwv_flow_api.g_varchar2_table(25) := '29207B0A20202E646D2D4865616465722D6C6F676F49636F6E207B0A202020206D617267696E2D72696768743A203870783B0A20207D0A0A20202E646D2D4865616465722D6C6F676F4C6162656C207B0A20202020666F6E742D73697A653A2031367078';
wwv_flow_api.g_varchar2_table(26) := '3B0A20207D0A7D0A0A2E646D2D4865616465724E6176207B0A20206D617267696E3A20303B0A20206D617267696E2D6C6566743A206175746F3B0A202070616464696E673A20303B0A20206C6973742D7374796C653A206E6F6E653B0A20202D6D732D67';
wwv_flow_api.g_varchar2_table(27) := '7269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A2E646D2D4865616465724E6176206C69207B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A2020766572746963';
wwv_flow_api.g_varchar2_table(28) := '616C2D616C69676E3A20746F703B0A7D0A0A2E646D2D4865616465724E61762D6C696E6B207B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206D617267696E2D6C6566743A206175746F3B0A202070616464696E673A203870783B';
wwv_flow_api.g_varchar2_table(29) := '0A2020766572746963616C2D616C69676E3A20746F703B0A202077686974652D73706163653A206E6F777261703B0A2020666F6E742D73697A653A20313470783B0A20206C696E652D6865696768743A20313670783B0A2020636F6C6F723A2023666666';
wwv_flow_api.g_varchar2_table(30) := '3B0A2020636F6C6F723A2072676261283235352C3235352C3235352C2E3935293B0A2020626F726465722D7261646975733A203470783B0A2020626F782D736861646F773A20696E7365742072676261283235352C3235352C3235352C2E323529203020';
wwv_flow_api.g_varchar2_table(31) := '302030203170783B0A7D0A0A406D656469612073637265656E20616E6420286D696E2D77696474683A20333630707829207B0A20202E646D2D4865616465724E61762D6C696E6B207B0A2020202070616464696E673A2038707820313270783B0A20207D';
wwv_flow_api.g_varchar2_table(32) := '0A7D0A0A2E646D2D4865616465724E61762D6C696E6B3A686F766572207B0A2020636F6C6F723A20236666663B0A2020626F782D736861646F773A20696E7365742023666666203020302030203170783B0A7D0A0A2E646D2D4865616465724E61762D69';
wwv_flow_api.g_varchar2_table(33) := '636F6E207B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A202077696474683A20313670783B0A20206865696768743A20313670783B0A2020766572746963616C2D616C69676E3A20746F703B0A2020666F6E742D73697A653A203136';
wwv_flow_api.g_varchar2_table(34) := '70782021696D706F7274616E743B0A20206C696E652D6865696768743A20313670782021696D706F7274616E743B0A202066696C6C3A2063757272656E74436F6C6F723B0A7D0A0A2E646D2D4865616465724E61762D6C6162656C207B0A20206D617267';
wwv_flow_api.g_varchar2_table(35) := '696E2D6C6566743A203270783B0A7D0A0A406D656469612073637265656E20616E6420286D61782D77696474683A20373637707829207B0A20202E646D2D4865616465724E61762D6C6162656C207B0A20202020646973706C61793A206E6F6E653B0A20';
wwv_flow_api.g_varchar2_table(36) := '207D0A7D0A0A0A0A2E646D2D426F6479207B0A202070616464696E672D746F703A203870783B0A202070616464696E672D626F74746F6D3A20333270783B0A2020666C65782D67726F773A20313B0A2020666C65782D736872696E6B3A20313B0A202066';
wwv_flow_api.g_varchar2_table(37) := '6C65782D62617369733A206175746F3B0A7D0A0A2E646D2D436F6E7461696E6572207B0A20206D617267696E2D72696768743A206175746F3B0A20206D617267696E2D6C6566743A206175746F3B0A202070616464696E672D72696768743A2031367078';
wwv_flow_api.g_varchar2_table(38) := '3B0A202070616464696E672D6C6566743A20313670783B0A20206D61782D77696474683A203130323470783B0A7D0A0A0A0A2E646D2D466F6F746572207B0A202070616464696E672D746F703A20333270783B0A202070616464696E672D626F74746F6D';
wwv_flow_api.g_varchar2_table(39) := '3A20333270783B0A2020666F6E742D73697A653A20313270783B0A2020636F6C6F723A2072676261283235352C3235352C3235352C302E3535293B0A20206261636B67726F756E642D636F6C6F723A20233238326433313B0A2020666C65782D67726F77';
wwv_flow_api.g_varchar2_table(40) := '3A20303B0A2020746578742D616C69676E3A2063656E7465723B0A7D0A0A2E646D2D466F6F7465722061207B0A2020636F6C6F723A20236666663B0A7D0A0A2E646D2D466F6F7465722070207B0A20206D617267696E3A20303B0A7D0A0A2E646D2D466F';
wwv_flow_api.g_varchar2_table(41) := '6F74657220703A6E6F74283A66697273742D6368696C6429207B0A20206D617267696E2D746F703A203870783B0A7D0A0A0A0A2E646D2D41626F7574207B0A20206D617267696E2D626F74746F6D3A20363470783B0A7D0A0A0A0A2E646D2D496E74726F';
wwv_flow_api.g_varchar2_table(42) := '207B0A2020746578742D616C69676E3A2063656E7465723B0A7D0A0A2E646D2D496E74726F2D69636F6E207B0A20206D617267696E2D746F703A202D363470783B0A20206D617267696E2D72696768743A206175746F3B0A2F2A0A2020636F6C6F723A20';
wwv_flow_api.g_varchar2_table(43) := '236666663B0A20206261636B67726F756E642D636F6C6F723A20233035373243453B0A20206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E742872676261283235352C3235352C3235352C2E31292C7267626128323535';
wwv_flow_api.g_varchar2_table(44) := '2C3235352C3235352C3029293B0A2020626F782D736861646F773A207267626128302C302C302C2E312920302038707820333270783B0A2A2F0A20206D617267696E2D626F74746F6D3A20323470783B0A20206D617267696E2D6C6566743A206175746F';
wwv_flow_api.g_varchar2_table(45) := '3B0A202070616464696E673A20333270783B0A202077696474683A2031323870783B0A20206865696768743A2031323870783B0A2020636F6C6F723A20233035373243453B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A2020626F';
wwv_flow_api.g_varchar2_table(46) := '726465722D7261646975733A20313030253B0A2020626F782D736861646F773A207267626128302C302C302C2E312920302038707820333270783B0A7D0A0A406D656469612073637265656E20616E6420286D61782D77696474683A2037363770782920';
wwv_flow_api.g_varchar2_table(47) := '7B0A20202E646D2D496E74726F2D69636F6E207B0A202020206D617267696E2D746F703A20303B0A20207D0A7D0A0A2E646D2D496E74726F2D69636F6E20737667207B0A2020646973706C61793A20626C6F636B3B0A202077696474683A20363470783B';
wwv_flow_api.g_varchar2_table(48) := '0A20206865696768743A20363470783B0A202066696C6C3A2063757272656E74636F6C6F723B0A7D0A0A2E646D2D496E74726F206831207B0A20206D617267696E2D626F74746F6D3A203870783B0A2020666F6E742D7765696768743A203730303B0A20';
wwv_flow_api.g_varchar2_table(49) := '20666F6E742D73697A653A20343070783B0A20206C696E652D6865696768743A20343870783B0A7D0A0A2E646D2D496E74726F2070207B0A20206D617267696E3A2030203020323470783B0A2020666F6E742D73697A653A20313870783B0A20206F7061';
wwv_flow_api.g_varchar2_table(50) := '636974793A202E36353B0A7D0A0A2E646D2D496E74726F20703A6C6173742D6368696C64207B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A0A0A0A2E646D2D536561726368426F78207B0A2020646973706C61793A20666C65783B0A20206D';
wwv_flow_api.g_varchar2_table(51) := '617267696E2D746F703A203070783B0A20206D617267696E2D626F74746F6D3A20313570783B0A7D0A0A2E646D2D536561726368426F782D73657474696E6773207B0A20206D617267696E2D6C6566743A203570783B0A2020666C65782D67726F773A20';
wwv_flow_api.g_varchar2_table(52) := '303B0A2020666C65782D736872696E6B3A20303B0A2020666C65782D62617369733A206175746F3B0A20202D6D732D677269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A2E646D2D';
wwv_flow_api.g_varchar2_table(53) := '536561726368426F782D77726170207B0A2020706F736974696F6E3A2072656C61746976653B0A2020666C65782D67726F773A20313B0A2020666C65782D736872696E6B3A20313B0A2020666C65782D62617369733A206175746F3B0A20202D6D732D67';
wwv_flow_api.g_varchar2_table(54) := '7269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A2E646D2D536561726368426F782D69636F6E207B0A2020706F736974696F6E3A206162736F6C7574652021696D706F7274616E74';
wwv_flow_api.g_varchar2_table(55) := '3B0A2020746F703A203530253B0A20206C6566743A20313270783B0A2020666F6E742D73697A653A20313870782021696D706F7274616E743B0A20206C696E652D6865696768743A20313B0A20202D7765626B69742D7472616E73666F726D3A20747261';
wwv_flow_api.g_varchar2_table(56) := '6E736C61746559282D353025293B0A20207472616E73666F726D3A207472616E736C61746559282D353025293B0A7D0A0A2E646D2D536561726368426F782D696E707574207B0A2020646973706C61793A20626C6F636B3B0A20206D617267696E3A2030';
wwv_flow_api.g_varchar2_table(57) := '3B0A202070616464696E673A20357078203570782035707820333570783B0A202077696474683A20313030253B0A20206865696768743A20333070783B0A2020666F6E742D7765696768743A203430303B0A2020666F6E742D73697A653A20323070783B';
wwv_flow_api.g_varchar2_table(58) := '0A2020636F6C6F723A20233030303B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A20206F75746C696E653A206E6F6E653B0A2020626F726465723A2031707820736F6C6964207267626128302C302C302C2E3135293B0A2020626F';
wwv_flow_api.g_varchar2_table(59) := '726465722D7261646975733A203470783B0A20202D7765626B69742D617070656172616E63653A206E6F6E653B0A20202D6D6F7A2D617070656172616E63653A206E6F6E653B0A2020617070656172616E63653A206E6F6E653B0A7D0A0A2E646D2D5365';
wwv_flow_api.g_varchar2_table(60) := '61726368426F782D696E7075743A666F637573207B0A2020626F726465722D636F6C6F723A20233035373243453B0A7D0A0A2E646D2D536561726368426F782D696E7075743A3A2D7765626B69742D7365617263682D6465636F726174696F6E207B0A20';
wwv_flow_api.g_varchar2_table(61) := '202D7765626B69742D617070656172616E63653A206E6F6E653B0A7D0A0A406D656469612073637265656E20616E6420286D61782D77696474683A20343739707829207B0A20202E646D2D536561726368426F78207B0A20202020666C65782D64697265';
wwv_flow_api.g_varchar2_table(62) := '6374696F6E3A20636F6C756D6E3B0A2020202077696474683A20313030253B0A20207D0A0A20202E646D2D536561726368426F782D77726170207B0A202020202D6D732D677269642D726F772D616C69676E3A206175746F3B0A20202020616C69676E2D';
wwv_flow_api.g_varchar2_table(63) := '73656C663A206175746F3B0A20207D0A0A20202E646D2D536561726368426F782D73657474696E6773207B0A202020206D617267696E2D746F703A203870783B0A202020206D617267696E2D6C6566743A20303B0A202020202D6D732D677269642D726F';
wwv_flow_api.g_varchar2_table(64) := '772D616C69676E3A206175746F3B0A20202020616C69676E2D73656C663A206175746F3B0A20207D0A7D0A0A0A0A2E646D2D536561726368207B0A0A7D0A0A2E646D2D5365617263682D63617465676F7279207B0A20206D617267696E2D626F74746F6D';
wwv_flow_api.g_varchar2_table(65) := '3A20313670783B0A202070616464696E673A20313670783B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A2020626F726465723A2031707820736F6C6964207267626128302C302C302C2E3135293B0A2020626F726465722D726164';
wwv_flow_api.g_varchar2_table(66) := '6975733A203870783B0A7D0A0A2E646D2D5365617263682D63617465676F72793A6C6173742D6368696C64207B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A0A2E646D2D5365617263682D7469746C65207B0A20206D617267696E3A20303B';
wwv_flow_api.g_varchar2_table(67) := '0A2020746578742D616C69676E3A2063656E7465723B0A2020746578742D7472616E73666F726D3A206361706974616C697A653B0A2020666F6E742D7765696768743A203530303B0A2020666F6E742D73697A653A20323470783B0A20206F7061636974';
wwv_flow_api.g_varchar2_table(68) := '793A202E36353B0A7D0A0A2E646D2D5365617263682D6C6973743A6F6E6C792D6368696C64207B0A20206D617267696E3A20302021696D706F7274616E743B0A7D0A0A0A2E646D2D5365617263682D6C697374207B0A2020646973706C61793A20666C65';
wwv_flow_api.g_varchar2_table(69) := '783B0A20206D617267696E3A2031367078203020303B0A202070616464696E673A20303B0A20206C6973742D7374796C653A206E6F6E653B0A2020666C65782D777261703A20777261703B0A2020616C69676E2D6974656D733A20666C65782D73746172';
wwv_flow_api.g_varchar2_table(70) := '743B0A20206A7573746966792D636F6E74656E743A20666C65782D73746172743B0A7D0A0A2E646D2D5365617263682D6C6973743A656D707479207B0A2020646973706C61793A206E6F6E653B0A7D0A0A2E646D2D5365617263682D6C697374206C6920';
wwv_flow_api.g_varchar2_table(71) := '7B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A202077696474683A2063616C6328313030252F32293B0A7D0A0A406D656469612073637265656E20616E6420286D696E2D77696474683A20343830707829207B0A20202E646D2D5365';
wwv_flow_api.g_varchar2_table(72) := '617263682D6C697374206C69207B0A2020202077696474683A2063616C6328313030252F34293B0A20207D0A7D0A0A406D656469612073637265656E20616E6420286D696E2D77696474683A20373638707829207B0A20202E646D2D5365617263682D6C';
wwv_flow_api.g_varchar2_table(73) := '697374206C69207B0A2020202077696474683A2063616C632828313030252F3629202D20302E317078293B202F2A20466978204945313120526F756E64696E6720627567202A2F0A20207D0A7D0A0A406D656469612073637265656E20616E6420286D69';
wwv_flow_api.g_varchar2_table(74) := '6E2D77696474683A2031303234707829207B0A20202E646D2D5365617263682D6C697374206C69207B0A2020202077696474683A2063616C6328313030252F38293B0A20207D0A7D0A0A0A0A2E646D2D5365617263682D726573756C74207B0A20206469';
wwv_flow_api.g_varchar2_table(75) := '73706C61793A20666C65783B0A2020666C65782D646972656374696F6E3A20636F6C756D6E3B0A2020746578742D6465636F726174696F6E3A206E6F6E653B0A2020636F6C6F723A20696E68657269743B0A20202F2A206261636B67726F756E642D696D';
wwv_flow_api.g_varchar2_table(76) := '6167653A206C696E6561722D6772616469656E742872676261283235352C3235352C3235352C2E31292C72676261283235352C3235352C3235352C3029293B202A2F0A20206F75746C696E653A206E6F6E653B0A2020626F726465722D7261646975733A';
wwv_flow_api.g_varchar2_table(77) := '203470783B0A20202F2A207472616E736974696F6E3A202E317320656173653B202A2F0A7D0A0A2E646D2D5365617263682D69636F6E207B0A2020646973706C61793A20666C65783B0A2020666C65782D646972656374696F6E3A20636F6C756D6E3B0A';
wwv_flow_api.g_varchar2_table(78) := '202070616464696E673A20313670783B0A202077696474683A20313030253B0A2020636F6C6F723A20696E68657269743B0A2020616C69676E2D6974656D733A2063656E7465723B0A20206A7573746966792D636F6E74656E743A2063656E7465723B0A';
wwv_flow_api.g_varchar2_table(79) := '7D0A0A2E646D2D5365617263682D69636F6E202E6661207B0A2020666F6E742D73697A653A20313670783B0A7D0A0A2E666F7263652D66612D6C67202E646D2D5365617263682D69636F6E202E6661207B0A2020666F6E742D73697A653A20333270783B';
wwv_flow_api.g_varchar2_table(80) := '0A7D0A0A2E646D2D5365617263682D696E666F207B0A202070616464696E673A20387078203470783B0A2020746578742D616C69676E3A2063656E7465723B0A2020666F6E742D73697A653A20313270783B0A7D0A0A2E646D2D5365617263682D636C61';
wwv_flow_api.g_varchar2_table(81) := '7373207B0A20206F7061636974793A202E36353B0A20202F2A20637572736F723A20746578743B0A20202D7765626B69742D757365722D73656C6563743A20616C6C3B0A20202D6D6F7A2D757365722D73656C6563743A20616C6C3B0A20202D6D732D75';
wwv_flow_api.g_varchar2_table(82) := '7365722D73656C6563743A20616C6C3B0A2020757365722D73656C6563743A20616C6C3B202A2F0A7D0A0A2E646D2D5365617263682D726573756C743A666F637573207B0A2020626F782D736861646F773A207267626128302C302C302C2E3037352920';
wwv_flow_api.g_varchar2_table(83) := '3020347078203870782C20696E7365742023303537324345203020302030203170783B0A7D0A0A2E646D2D5365617263682D726573756C743A686F766572207B0A2020636F6C6F723A20236666663B0A20206261636B67726F756E642D636F6C6F723A20';
wwv_flow_api.g_varchar2_table(84) := '233035373243453B0A2020626F782D736861646F773A207267626128302C302C302C2E30373529203020347078203870783B0A7D0A0A2E646D2D5365617263682D726573756C743A666F6375733A686F766572207B0A2020626F782D736861646F773A20';
wwv_flow_api.g_varchar2_table(85) := '7267626128302C302C302C2E30373529203020347078203870782C20696E7365742023303537324345203020302030203170782C20696E7365742023666666203020302030203270783B0A7D0A0A2E646D2D5365617263682D726573756C743A686F7665';
wwv_flow_api.g_varchar2_table(86) := '72202E646D2D5365617263682D69636F6E207B0A7D0A0A2E646D2D5365617263682D726573756C743A686F766572202E646D2D5365617263682D696E666F207B0A20206261636B67726F756E642D636F6C6F723A207267626128302C302C302C2E313529';
wwv_flow_api.g_varchar2_table(87) := '3B0A7D0A0A2E646D2D5365617263682D726573756C743A686F766572202E646D2D5365617263682D636C617373207B0A20206F7061636974793A20313B0A7D0A0A2E646D2D5365617263682D726573756C743A616374697665207B0A2020626F782D7368';
wwv_flow_api.g_varchar2_table(88) := '61646F773A20696E736574207267626128302C302C302C2E323529203020327078203470783B0A7D0A0A0A0A2E646D2D49636F6E2D6E616D65207B0A20206D617267696E2D626F74746F6D3A20323470783B0A2020666F6E742D7765696768743A203730';
wwv_flow_api.g_varchar2_table(89) := '303B0A2020666F6E742D73697A653A20343070783B0A20206C696E652D6865696768743A20343870783B0A7D0A0A2E646D2D49636F6E207B0A2020646973706C61793A20666C65783B0A20206D617267696E2D626F74746F6D3A20313670783B0A7D0A0A';
wwv_flow_api.g_varchar2_table(90) := '2E646D2D49636F6E50726576696577207B0A2020666C65782D67726F773A20313B0A2020666C65782D62617369733A20313030253B0A7D0A0A2E646D2D49636F6E4275696C646572207B0A20206D617267696E2D6C6566743A20323470783B0A2020666C';
wwv_flow_api.g_varchar2_table(91) := '65782D67726F773A20303B0A2020666C65782D736872696E6B3A20303B0A2020666C65782D62617369733A2033332E33333333253B3B0A7D0A0A406D656469612073637265656E20616E6420286D61782D77696474683A20373637707829207B0A20202E';
wwv_flow_api.g_varchar2_table(92) := '646D2D49636F6E207B0A20202020666C65782D646972656374696F6E3A20636F6C756D6E3B0A20207D0A0A20202E646D2D49636F6E4275696C646572207B0A202020206D617267696E2D746F703A20313270783B0A202020206D617267696E2D6C656674';
wwv_flow_api.g_varchar2_table(93) := '3A20303B0A20207D0A7D0A0A2E646D2D49636F6E50726576696577207B0A2020646973706C61793A20666C65783B0A202070616464696E673A20313670783B0A20206D696E2D6865696768743A2031323870783B0A20206261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(94) := '6C6F723A20236666663B0A20206261636B67726F756E642D696D6167653A2075726C28646174613A696D6167652F7376672B786D6C3B6261736536342C50484E325A79423462577875637A30696148523063446F764C336433647935334D793576636D63';
wwv_flow_api.g_varchar2_table(95) := '764D6A41774D43397A646D6369494864705A48526F505349794D434967614756705A326830505349794D43492B436A78795A574E30494864705A48526F505349794D434967614756705A326830505349794D4349675A6D6C736244306949305A47526949';
wwv_flow_api.g_varchar2_table(96) := '2B504339795A574E3050676F38636D566A6443423361575230614430694D5441694947686C6157646F644430694D54416949475A706247773949694E474F455934526A6769506A7776636D566A6444344B50484A6C59335167654430694D54416949486B';
wwv_flow_api.g_varchar2_table(97) := '39496A45774969423361575230614430694D5441694947686C6157646F644430694D54416949475A706247773949694E474F455934526A6769506A7776636D566A6444344B5043397A646D632B293B0A20206261636B67726F756E642D706F736974696F';
wwv_flow_api.g_varchar2_table(98) := '6E3A203530253B0A20206261636B67726F756E642D73697A653A20313670783B0A2020626F726465723A2031707820736F6C6964207267626128302C302C302C2E3135293B0A2020626F726465722D7261646975733A203870783B0A2020616C69676E2D';
wwv_flow_api.g_varchar2_table(99) := '6974656D733A2063656E7465723B0A20206A7573746966792D636F6E74656E743A2063656E7465723B0A7D0A0A2E646D2D546F67676C65207B0A2020706F736974696F6E3A2072656C61746976653B0A2020646973706C61793A20626C6F636B3B0A2020';
wwv_flow_api.g_varchar2_table(100) := '6D617267696E3A20303B0A202077696474683A2031303070783B0A20206865696768743A20343870783B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A20206F75746C696E653A206E6F6E653B0A2020626F726465722D7261646975';
wwv_flow_api.g_varchar2_table(101) := '733A203470783B0A2020626F782D736861646F773A20696E736574207267626128302C302C302C2E313529203020302030203170783B0A2020637572736F723A20706F696E7465723B0A20207472616E736974696F6E3A202E317320656173653B0A2020';
wwv_flow_api.g_varchar2_table(102) := '2D7765626B69742D617070656172616E63653A206E6F6E653B0A20202D6D6F7A2D617070656172616E63653A206E6F6E653B0A2020617070656172616E63653A206E6F6E653B0A7D0A0A2E646D2D546F67676C653A6166746572207B0A2020706F736974';
wwv_flow_api.g_varchar2_table(103) := '696F6E3A206162736F6C7574653B0A2020746F703A203470783B0A20206C6566743A203470783B0A202077696474683A20343870783B0A20206865696768743A20343070783B0A2020636F6E74656E743A2022536D616C6C223B0A2020746578742D616C';
wwv_flow_api.g_varchar2_table(104) := '69676E3A2063656E7465723B0A2020666F6E742D7765696768743A203730303B0A2020666F6E742D73697A653A20313170783B0A20206C696E652D6865696768743A20343070783B0A2020636F6C6F723A207267626128302C302C302C2E3635293B0A20';
wwv_flow_api.g_varchar2_table(105) := '206261636B67726F756E643A207472616E73706172656E743B0A20206261636B67726F756E642D636F6C6F723A20236630663066303B0A2020626F726465722D7261646975733A203270783B0A2020626F782D736861646F773A20696E73657420726762';
wwv_flow_api.g_varchar2_table(106) := '6128302C302C302C2E313529203020302030203170783B0A20207472616E736974696F6E3A202E317320656173653B0A7D0A0A2E646D2D546F67676C653A636865636B6564207B0A20206261636B67726F756E642D636F6C6F723A20233035373243453B';
wwv_flow_api.g_varchar2_table(107) := '0A7D0A0A2E646D2D546F67676C653A636865636B65643A6166746572207B0A20206C6566743A20343870783B0A2020636F6E74656E743A20274C61726765273B0A2020636F6C6F723A20233035373243453B0A20206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(108) := '723A20236666663B0A2020626F782D736861646F773A207267626128302C302C302C2E313529203020302030203170783B0A7D0A0A0A0A2E646D2D526164696F50696C6C536574207B0A2020646973706C61793A20666C65783B0A202077696474683A20';
wwv_flow_api.g_varchar2_table(109) := '313030253B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A2020626F726465722D7261646975733A203470783B0A2020626F782D736861646F773A20696E73657420302030203020317078207267626128302C302C302C2E3135293B';
wwv_flow_api.g_varchar2_table(110) := '0A7D0A0A2E646D2D526164696F50696C6C5365742D6F7074696F6E207B0A2020666C65782D67726F773A20313B0A2020666C65782D736872696E6B3A20303B0A2020666C65782D62617369733A206175746F3B0A7D0A0A2E646D2D526164696F50696C6C';
wwv_flow_api.g_varchar2_table(111) := '5365742D6F7074696F6E3A6E6F74283A66697273742D6368696C6429207B0A2020626F726465722D6C6566743A2031707820736F6C6964207267626128302C302C302C2E3135293B0A7D0A0A2E646D2D526164696F50696C6C5365742D6F7074696F6E3A';
wwv_flow_api.g_varchar2_table(112) := '66697273742D6368696C6420696E707574202B206C6162656C207B0A2020626F726465722D746F702D6C6566742D7261646975733A203470783B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203470783B0A7D0A0A2E646D2D';
wwv_flow_api.g_varchar2_table(113) := '526164696F50696C6C5365742D6F7074696F6E3A6C6173742D6368696C6420696E707574202B206C6162656C207B0A2020626F726465722D746F702D72696768742D7261646975733A203470783B0A2020626F726465722D626F74746F6D2D7269676874';
wwv_flow_api.g_varchar2_table(114) := '2D7261646975733A203470783B0A7D0A0A2E646D2D526164696F50696C6C5365742D6F7074696F6E20696E707574207B0A2020706F736974696F6E3A206162736F6C7574653B0A20206F766572666C6F773A2068696464656E3B0A2020636C69703A2072';
wwv_flow_api.g_varchar2_table(115) := '6563742830203020302030293B0A20206D617267696E3A202D3170783B0A202070616464696E673A20303B0A202077696474683A203170783B0A20206865696768743A203170783B0A2020626F726465723A20303B0A7D0A0A2E646D2D526164696F5069';
wwv_flow_api.g_varchar2_table(116) := '6C6C5365742D6F7074696F6E20696E707574202B206C6162656C207B0A2020646973706C61793A20626C6F636B3B0A202070616464696E673A2038707820313270783B0A2020746578742D616C69676E3A2063656E7465723B0A2020666F6E742D73697A';
wwv_flow_api.g_varchar2_table(117) := '653A20313270783B0A20206C696E652D6865696768743A20313670783B0A2020636F6C6F723A20233338333833383B0A2020637572736F723A20706F696E7465723B0A7D0A0A2E646D2D526164696F50696C6C5365742D6F7074696F6E20696E7075743A';
wwv_flow_api.g_varchar2_table(118) := '636865636B6564202B206C6162656C207B0A2020666F6E742D7765696768743A203730303B0A2020636F6C6F723A20236639663966393B0A20206261636B67726F756E642D636F6C6F723A20233035373243453B0A7D0A0A2E646D2D526164696F50696C';
wwv_flow_api.g_varchar2_table(119) := '6C5365742D6F7074696F6E20696E7075743A666F637573202B206C6162656C207B0A2020626F782D736861646F773A20696E7365742023303537324345203020302030203170782C20696E7365742023666666203020302030203270783B0A7D0A0A2E64';
wwv_flow_api.g_varchar2_table(120) := '6D2D526164696F50696C6C5365742D2D6C61726765202E646D2D526164696F50696C6C5365742D6F7074696F6E20696E707574202B206C6162656C207B0A202070616464696E673A2035707820323470783B0A2020666F6E742D73697A653A2031347078';
wwv_flow_api.g_varchar2_table(121) := '3B0A20206C696E652D6865696768743A20323070783B0A7D0A0A0A0A0A0A0A0A2E646D2D526164696F536574207B0A2020646973706C61793A20666C65783B0A2020666C65782D777261703A20777261703B0A7D0A0A2E646D2D526164696F5365742D6F';
wwv_flow_api.g_varchar2_table(122) := '7074696F6E207B0A7D0A0A2E646D2D526164696F5365742D6F7074696F6E20696E707574207B0A2020706F736974696F6E3A206162736F6C7574653B0A20206F766572666C6F773A2068696464656E3B0A2020636C69703A207265637428302030203020';
wwv_flow_api.g_varchar2_table(123) := '30293B0A20206D617267696E3A202D3170783B0A202070616464696E673A20303B0A202077696474683A203170783B0A20206865696768743A203170783B0A2020626F726465723A20303B0A7D0A0A2E646D2D526164696F5365742D6F7074696F6E2069';
wwv_flow_api.g_varchar2_table(124) := '6E707574202B206C6162656C207B0A2020646973706C61793A20666C65783B0A2020666C65782D646972656374696F6E3A20636F6C756D6E3B0A202070616464696E673A203870783B0A202077696474683A20383070783B0A20206865696768743A2038';
wwv_flow_api.g_varchar2_table(125) := '3070783B0A2020746578742D616C69676E3A2063656E7465723B0A2020626F726465722D7261646975733A203470783B0A2020637572736F723A20706F696E7465723B0A2020616C69676E2D6974656D733A2063656E7465723B0A7D0A0A2E646D2D5261';
wwv_flow_api.g_varchar2_table(126) := '64696F5365742D69636F6E207B0A20206D617267696E3A203870783B0A20202D6D732D677269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A2E646D2D526164696F5365742D6C6162';
wwv_flow_api.g_varchar2_table(127) := '656C207B0A2020646973706C61793A20626C6F636B3B0A2020666F6E742D73697A653A20313270783B0A20206C696E652D6865696768743A20313670783B0A20202D6D732D677269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E';
wwv_flow_api.g_varchar2_table(128) := '2D73656C663A2063656E7465723B0A7D0A0A2E646D2D526164696F5365742D6F7074696F6E20696E7075743A636865636B6564202B206C6162656C207B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A2020626F782D736861646F77';
wwv_flow_api.g_varchar2_table(129) := '3A20696E7365742023303537324345203020302030203170783B0A7D0A0A0A0A2E646D2D4669656C64207B0A2020646973706C61793A20666C65783B0A20206D617267696E2D626F74746F6D3A20313270783B0A7D0A0A2E646D2D4669656C643A6C6173';
wwv_flow_api.g_varchar2_table(130) := '742D6368696C64207B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A0A2E646D2D4669656C644C6162656C207B0A2020646973706C61793A20626C6F636B3B0A20206D617267696E2D72696768743A20313270783B0A202077696474683A2031';
wwv_flow_api.g_varchar2_table(131) := '303070783B0A2020746578742D616C69676E3A2072696768743B0A20202F2A206D617267696E2D626F74746F6D3A203270783B202A2F0A2020666F6E742D73697A653A20313370783B0A2020636F6C6F723A207267626128302C302C302C2E3635293B0A';
wwv_flow_api.g_varchar2_table(132) := '2020666C65782D736872696E6B3A20303B0A20202D6D732D677269642D726F772D616C69676E3A2063656E7465723B0A2020616C69676E2D73656C663A2063656E7465723B0A7D0A0A406D656469612073637265656E20616E6420286D61782D77696474';
wwv_flow_api.g_varchar2_table(133) := '683A20343739707829207B0A20202E646D2D4669656C64207B0A20202020666C65782D646972656374696F6E3A20636F6C756D6E3B0A20207D0A0A20202E646D2D4669656C643A6C6173742D6368696C64207B0A202020206D617267696E2D626F74746F';
wwv_flow_api.g_varchar2_table(134) := '6D3A20303B0A20207D0A0A20202E646D2D4669656C644C6162656C207B0A202020206D617267696E2D72696768743A20303B0A202020206D617267696E2D626F74746F6D3A203470783B0A2020202077696474683A20313030253B0A2020202074657874';
wwv_flow_api.g_varchar2_table(135) := '2D616C69676E3A206C6566743B0A20207D0A7D0A0A2E646D2D4669656C642073656C656374207B0A2020646973706C61793A20626C6F636B3B0A20206D617267696E3A20303B0A202070616464696E673A20387078203332707820387078203870783B0A';
wwv_flow_api.g_varchar2_table(136) := '202077696474683A20313030253B0A2020666F6E742D73697A653A20313470783B0A20206C696E652D6865696768743A20313B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A20206261636B67726F756E642D696D6167653A207572';
wwv_flow_api.g_varchar2_table(137) := '6C28646174613A696D6167652F7376672B786D6C3B6261736536342C50484E325A79423462577875637A30696148523063446F764C336433647935334D793576636D63764D6A41774D43397A646D6369494864705A48526F505349304D4441694947686C';
wwv_flow_api.g_varchar2_table(138) := '6157646F644430694D6A41774969423261575633516D3934505349744F546B754E5341774C6A55674E444177494449774D4349675A573568596D786C4C574A685932746E636D3931626D5139496D356C647941744F546B754E5341774C6A55674E444177';
wwv_flow_api.g_varchar2_table(139) := '494449774D43492B50484268644767675A6D6C7362443069497A51304E4349675A443069545445314E6934794E5341334D793433597A41674D5334324C5334324D5449674D7934794C5445754F444931494451754E444931624330314E4334304D6A5567';
wwv_flow_api.g_varchar2_table(140) := '4E5451754E4449314C5455304C6A51794E5330314E4334304D6A566A4C5449754E444D344C5449754E444D344C5449754E444D344C5459754E4341774C5467754F444D33637A59754E4330794C6A517A4F4341344C6A677A4E794177624451314C6A5534';
wwv_flow_api.g_varchar2_table(141) := '4F4341304E5334314E7A51674E4455754E5463314C5451314C6A55334E574D794C6A517A4F4330794C6A517A4F4341324C6A4D354F5330794C6A517A4F4341344C6A677A4E794177494445754D6A4932494445754D6A4932494445754F444D3449444975';
wwv_flow_api.g_varchar2_table(142) := '4F444931494445754F444D34494451754E44457A65694976506A777663335A6E50673D3D293B0A20206261636B67726F756E642D706F736974696F6E3A2031303025203530253B0A20206261636B67726F756E642D73697A653A20333270782031367078';
wwv_flow_api.g_varchar2_table(143) := '3B0A20206261636B67726F756E642D7265706561743A206E6F2D7265706561743B0A20206F75746C696E653A206E6F6E653B0A2020626F726465723A2031707820736F6C6964207267626128302C302C302C2E32293B0A2020626F726465722D72616469';
wwv_flow_api.g_varchar2_table(144) := '75733A203470783B0A20202D7765626B69742D617070656172616E63653A206E6F6E653B0A20202D6D6F7A2D617070656172616E63653A206E6F6E653B0A2020617070656172616E63653A206E6F6E653B0A7D0A0A2E646D2D4669656C642073656C6563';
wwv_flow_api.g_varchar2_table(145) := '743A3A2D6D732D657870616E64207B0A2020646973706C61793A206E6F6E653B0A7D0A0A2E646D2D4669656C642073656C6563743A666F637573207B0A2020626F726465722D636F6C6F723A20233035373243453B0A7D0A0A0A0A0A2E646D2D49636F6E';
wwv_flow_api.g_varchar2_table(146) := '4F7574707574207B0A2020646973706C61793A20666C65783B0A2020666C65782D777261703A206E6F777261703B0A2020616C69676E2D6974656D733A20666C65782D73746172743B0A7D0A0A2E646D2D49636F6E4F7574707574203E202E646D2D4963';
wwv_flow_api.g_varchar2_table(147) := '6F6E4F75747075742D636F6C206832207B0A2020646973706C61793A20626C6F636B3B0A2020666F6E742D73697A653A20313270783B0A2020666C65782D67726F773A20313B0A2020666C65782D736872696E6B3A20313B0A2020666C65782D62617369';
wwv_flow_api.g_varchar2_table(148) := '733A206175746F3B0A2020616C69676E2D73656C663A20666C65782D73746172743B0A20206D617267696E3A20303B0A2020666F6E742D7765696768743A206E6F726D616C3B0A7D0A0A2E646D2D49636F6E4F7574707574203E202E646D2D49636F6E4F';
wwv_flow_api.g_varchar2_table(149) := '75747075742D636F6C2D2D68746D6C207B0A2020666C65782D67726F773A20313B0A2020666C65782D736872696E6B3A20313B0A2020666C65782D62617369733A206175746F3B0A7D0A0A2E646D2D49636F6E4F7574707574203E202E646D2D49636F6E';
wwv_flow_api.g_varchar2_table(150) := '4F75747075742D636F6C2D2D636C617373207B0A7D0A0A2E646D2D49636F6E4F7574707574203E202E646D2D49636F6E4F75747075742D636F6C2D2D646F776E6C6F6164207B0A2020616C69676E2D73656C663A20666C65782D73746172743B0A202074';
wwv_flow_api.g_varchar2_table(151) := '6578742D616C69676E3A2063656E7465723B0A20206D617267696E2D746F703A20313870783B0A2020666C65782D67726F773A20303B0A7D0A0A2E646D2D49636F6E4F7574707574203E202E646D2D49636F6E4F75747075742D636F6C3A6E6F74283A66';
wwv_flow_api.g_varchar2_table(152) := '697273742D6368696C6429207B0A20206D617267696E2D6C6566743A20313670783B0A7D0A0A2E646D2D436F6465207B0A2020646973706C61793A20626C6F636B3B0A202070616464696E673A2038707820313270783B0A20206D61782D77696474683A';
wwv_flow_api.g_varchar2_table(153) := '20313030253B0A2020666F6E742D73697A653A20313270783B0A2020666F6E742D66616D696C793A206D6F6E6F73706163653B0A20206C696E652D6865696768743A20313670783B0A2020636F6C6F723A2072676261283235352C3235352C3235352C2E';
wwv_flow_api.g_varchar2_table(154) := '3735293B0A20206261636B67726F756E642D636F6C6F723A20233331333733633B0A2020626F726465722D7261646975733A203470783B0A2020637572736F723A20746578743B0A20202D7765626B69742D757365722D73656C6563743A20616C6C3B0A';
wwv_flow_api.g_varchar2_table(155) := '20202D6D6F7A2D757365722D73656C6563743A20616C6C3B0A20202D6D732D757365722D73656C6563743A20616C6C3B0A2020757365722D73656C6563743A20616C6C3B0A7D0A0A406D656469612073637265656E20616E6420286D61782D7769647468';
wwv_flow_api.g_varchar2_table(156) := '3A20373637707829207B0A20202E646D2D49636F6E4F7574707574207B0A20202020666C65782D646972656374696F6E3A20636F6C756D6E3B0A202020206D617267696E2D746F703A20333270783B0A20207D0A0A20202E646D2D49636F6E4F75747075';
wwv_flow_api.g_varchar2_table(157) := '74203E202E646D2D49636F6E4F75747075742D636F6C207B0A2020202077696474683A20313030253B0A202020202D6D732D677269642D726F772D616C69676E3A206175746F3B0A202020616C69676E2D73656C663A206175746F3B0A20207D0A0A2020';
wwv_flow_api.g_varchar2_table(158) := '2E646D2D49636F6E4F7574707574203E202E646D2D49636F6E4F75747075742D636F6C3A6E6F74283A66697273742D6368696C6429207B0A202020206D617267696E2D746F703A20313670783B0A202020206D617267696E2D6C6566743A20303B0A2020';
wwv_flow_api.g_varchar2_table(159) := '7D0A0A20202E646D2D436F6465207B0A2020202077696474683A20313030253B0A20207D0A7D0A0A0A0A2E646D2D44657363207B0A2020666F6E742D73697A653A20313270783B0A2020636F6C6F723A207267626128302C302C302C2E35293B0A7D0A0A';
wwv_flow_api.g_varchar2_table(160) := '0A0A2E646D2D4578616D706C6573207B0A20206D617267696E2D746F703A20343870783B0A7D0A0A0A2E646D2D4578616D706C6573206832207B0A20206D617267696E3A2030203020313270783B0A2020666F6E742D7765696768743A203530303B0A20';
wwv_flow_api.g_varchar2_table(161) := '20666F6E742D73697A653A20323470783B0A7D0A0A0A0A2E646D2D5072657669657773207B0A2020646973706C61793A20666C65783B0A20206D617267696E2D72696768743A202D3870783B0A20206D617267696E2D6C6566743A202D3870783B0A2020';
wwv_flow_api.g_varchar2_table(162) := '666C65782D777261703A20777261703B0A7D0A0A406D656469612073637265656E20616E6420286D61782D77696474683A20373637707829207B0A20202E646D2D5072657669657773202E646D2D50726576696577207B0A2020202077696474683A2031';
wwv_flow_api.g_varchar2_table(163) := '3030253B0A20207D0A7D0A0A0A0A2E646D2D50726576696577207B0A2020646973706C61793A20666C65783B0A20206F766572666C6F773A2068696464656E3B0A20206D617267696E2D72696768743A203870783B0A20206D617267696E2D626F74746F';
wwv_flow_api.g_varchar2_table(164) := '6D3A20313670783B0A20206D617267696E2D6C6566743A203870783B0A202070616464696E673A20313670783B0A202077696474683A2063616C6328353025202D2031367078293B0A20202F2A206261636B67726F756E642D636F6C6F723A2023666666';
wwv_flow_api.g_varchar2_table(165) := '3B202A2F0A20206261636B67726F756E642D636F6C6F723A20234644464446443B0A2020626F726465723A2031707820736F6C6964207267626128302C302C302C2E3135293B0A2020626F726465722D7261646975733A203470783B0A20202F2A20626F';
wwv_flow_api.g_varchar2_table(166) := '782D736861646F773A20696E736574207267626128302C302C302C2E30352920302038707820313670783B202A2F0A2020637572736F723A2064656661756C743B0A20202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A20202D6D6F';
wwv_flow_api.g_varchar2_table(167) := '7A2D757365722D73656C6563743A206E6F6E653B0A20202D6D732D757365722D73656C6563743A206E6F6E653B0A2020757365722D73656C6563743A206E6F6E653B0A7D0A0A2E646D2D507265766965772D2D6E6F506164207B0A202070616464696E67';
wwv_flow_api.g_varchar2_table(168) := '3A20303B0A7D0A0A2E612D4947202E69672D7370616E2D69636F6E2D7069636B6572207B0A2020202070616464696E673A203370783B0A09706F736974696F6E3A7374617469632021696D706F7274616E743B0A7D0A0A2E612D4947202E69672D627574';
wwv_flow_api.g_varchar2_table(169) := '746F6E2D69636F6E2D7069636B6572207B0A2020202070616464696E673A20307078203470783B0A7D0A0A0A2E69672D6469762D69636F6E2D7069636B6572207B0A09706F736974696F6E3A72656C61746976653B0A0977696474683A313030253B0A7D';
wwv_flow_api.g_varchar2_table(170) := '0A0A2E69672D6469762D69636F6E2D7069636B6572202E69672D627574746F6E2D69636F6E2D7069636B65723A6E6F74282E69702D69636F6E2D6F6E6C7929207B0A09706F736974696F6E3A6162736F6C7574653B0A09746F703A3070783B0A09726967';
wwv_flow_api.g_varchar2_table(171) := '68743A3070783B0A096865696768743A313030253B0A7D0A0A2E69672D6469762D69636F6E2D7069636B6572202E69672D696E7075742D69636F6E2D7069636B6572207B0A0977696474683A313030253B0A7D0A0A2E69672D6469762D69636F6E2D7069';
wwv_flow_api.g_varchar2_table(172) := '636B6572202E69702D69636F6E2D6F6E6C79207B0A09706F736974696F6E3A72656C61746976653B0A096865696768743A313030253B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(18528522380786576)
,p_plugin_id=>wwv_flow_api.id(18526883808784064)
,p_file_name=>'IPui.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
