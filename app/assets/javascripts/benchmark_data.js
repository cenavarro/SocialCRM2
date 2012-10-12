function add_new_competitor(){
  var html_select = document.getElementById('competitors_');
  var option_value = document.getElementById('newOption');
  if(html_select.length > 7){
    alert("No se pueden agregar mas de 8 competidores!");
    return false;
  }
  if (option_value.value != ''){
    var select_box_option = document.createElement("option");
    select_box_option.value = option_value.value;
    select_box_option.text = option_value.value;
    html_select.add(select_box_option, null);
    option_value.value = '';
    option_value.focus();
    return true;
  }
  alert("El canal no puede ser vacio!");
  return false;
}

function remove_competitor(){
  var html_select = document.getElementById('competitors_');
  if (html_select.options.length != 0){
    var option_to_remove = html_select.options.selectedIndex;
    html_select.remove(option_to_remove);
    if(html_select.options.length > 0){
      html_select.options[0].selected = true;
    }
    var option_value = document.getElementById('newOption');
    option_value.focus();
    return true;
  }
  alert("No hay mas elementos por eliminar!");
  return false;
}

function select_all_competitor_items(){
  var html_list_box = document.getElementById('competitors_');
  if(html_list_box.options.length > 0){
    for( var i=0; i < html_list_box.length; i++)
      html_list_box.options[i].selected=true;
  }
  return true;
}
