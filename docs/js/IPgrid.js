const IPinit = (itemId, options) => {
  const { readOnly, isRequired, pName, defIcon, showText, pDWidth, pDHeight, pDTitle,pReszie, pIconLabels, pDplaceholder, pDsmall, pDlarge} = options;
  let index = 0;
  const item$ = $(`#${itemId}`);
  const sr$ = item$.addClass('u-vh is-focusable')
	.parent();

  const render = (full, value) => {
	var p_val = value||"fa-navicon";
    const out = apex.util.htmlBuilder();
    out.markup('<div')
      .attr('class', 'ig-div-icon-picker')
      .markup('><button')
	  .attr('id', pName+'_lov_btn')
	  .attr('type', 'button')
	  .attr('class', 't-Button t-Button--noLabel t-Button--icon ig-button-icon-picker'+(!showText?' ip-icon-only':''))
	  .markup('><span')
	  .attr('class', ' ig-span-icon-picker fa '+p_val)
	  .attr('aria-hidden', true)
	  .optionalAttr('disabled', readOnly)
	  .markup(' /></button><input')
      .attr('type', showText?'text':'hidden')
	  .attr('class', 'ig-input-icon-picker')
      .attr('id', `${itemId}_${index}_0`)
      .attr('name', `${itemId}_${index}`)
      .attr('value', value)
      .attr('tabindex', -1)
      .optionalAttr('disabled', readOnly)
      .markup(' /><label')
      .attr('for', `${itemId}_${index}_0`)
      .markup('>')
      .content('')
      .markup('</label>')
	  .markup(' </div>');

    index += 1;

    return out.toString();
  };

	const attachButtonclick = () => {
	  $('button[id="'+pName+'_lov_btn"].ig-button-icon-picker').each((i, e) => {
		console.log("attach on button :", $(e));
		
		$(e).on('click', (k) => {
			const input$ = $(e).parent().find('input.igiconpicker:first');
			const rowId = input$.closest('tr').data('id');
			const regionId = $(input$.parents('.a-IG')).attr('id').slice(0, -3);
			 $("#IconPickerDialogBox").dialog("option", "modalItem", true)
									.dialog("option", "width", pDWidth)
									.dialog("option", "height", pDHeight)
									.dialog("option", "title", pDTitle)
									.dialog("option", "resizable", pReszie)
									.dialog("option", "tirggElem", pName)
									.dialog("option", "showIconLabel", pIconLabels)
									.dialog("option", "tirggItem", {regionId:regionId, rowId:rowId, column:itemId})
									.html('<main class="dm-Body"><div class="dm-Container"><div class="dm-SearchBox"><label class="dm-AccessibleHidden" for="search">Search</label><div class="dm-SearchBox-wrap"><span class="dm-SearchBox-icon fa fa-search" aria-hidden="true"></span><input id="search" class="dm-SearchBox-input" type="search" placeholder="'+pDplaceholder+'" aria-controls="icons" /></div><div class="dm-SearchBox-settings"><div class="dm-RadioPillSet dm-RadioPillSet--large" role="group" aria-label="Icon Size"><div class="dm-RadioPillSet-option"><input type="radio" id="icon_size_small" name="icon_size" value="SMALL"><label for="icon_size_small">'+pDsmall+'</label></div><div class="dm-RadioPillSet-option"><input type="radio" id="icon_size_large" name="icon_size" value="LARGE"><label for="icon_size_large">'+pDlarge+'</label></div></div></div></div><div id="icons" class="dm-Search" role="region" aria-live="polite"></div></div></main>')
									.dialog("open");
		});
	  });
	};

  
  if (!options.readOnly) {
    attachButtonclick(); 
	item$.closest('.ig-button-icon-picker').prop('disabled', true);
    item$.prop('disabled', true);
  }

	 
  
  apex.item.create(itemId, {
    setValue(value) {
      item$.val(value);
	  if (value)
		item$.closest('div.ig-div-icon-picker').find('span.ig-span-icon-picker').attr('class', 'apex-item-icon ig-span-icon-picker fa '+value);
	  else
		item$.closest('div.ig-div-icon-picker').find('span.ig-span-icon-picker').attr('class', 'apex-item-icon ig-span-icon-picker fa '+defIcon);  
    },
    disable() {
      item$.closest('.ig-div-icon-picker').removeClass('ig-div-icon-picker-enabled');
	  item$.closest('.ig-div-icon-picker').addClass('ig-div-icon-picker-disabled');
	  item$.closest('.ig-button-icon-picker').prop('disabled', true);
      item$.prop('disabled', true);
    },
    enable() {
      if (!options.readOnly) {
		item$.closest('.ig-div-icon-picker').removeClass('ig-div-icon-picker-disabled');
		item$.closest('.ig-div-icon-picker').addClass('ig-div-icon-picker-enabled');
		item$.closest('.ig-button-icon-picker').prop('disabled', false);
        item$.prop('disabled', false);
      }
    },
    displayValueFor(value) {
      return render(true, value);
    },
  });
  
};