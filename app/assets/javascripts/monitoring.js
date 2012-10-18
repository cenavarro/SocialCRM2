function addNewChannel(){
  var channels = document.getElementById('channels_');
  var new_channel = document.getElementById('newChannel');
  if (new_channel.value != ''){
    var new_box_option = document.createElement("option");
    new_box_option.value = new_channel.value;
    new_box_option.text = new_channel.value;
    channels.add(new_box_option, null);
    new_channel.value = '';
    new_channel.focus();
    return true;
  }
  alert("El canal no puede ser vacio!");
  return false;
}

function removeChannel(){
  var channels = document.getElementById('channels_');
  if (channels.options.length != 0){
    var option_to_remove = channels.options.selectedIndex;
    channels.remove(option_to_remove);
    if(channels.options.length > 0){
      channels.options[0].selected = true;
    }
    var new_channel = document.getElementById('newChannel');
    new_channel.focus();
    return true;
  }
  alert("No hay mas elementos por eliminar!");
  return false;
}

function addNewTheme(){
  var themes = document.getElementById('themes_');
  var new_theme = document.getElementById('newTheme');
  if (new_theme.value != ''){
    var new_box_option = document.createElement("option");
    new_box_option.value = new_theme.value;
    new_box_option.text = new_theme.value;
    themes.add(new_box_option, null);
    new_theme.value = '';
    new_theme.focus();
    return true;
  }
  alert("El canal no puede ser vacio!");
  return false;
}

function removeTheme(){
  var themes = document.getElementById('themes_');
  if (themes.options.length != 0){
    var option_to_remove = themes.options.selectedIndex;
    themes.remove(option_to_remove);
    if(themes.options.length > 0){
      themes.options[0].selected = true;
    }
    var new_theme = document.getElementById('newTheme');
    new_theme.focus();
    return true;
  }
  alert("No hay mas elementos por eliminar!");
  return false;
}

function selectAllItems(){
  var channels = document.getElementById('channels_');
  if(channels.options.length > 0){
    for(var i=0; i < channels.length; i++)
      channels.options[i].selected=true;
  }
  var themes = document.getElementById('themes_');
  if(themes.options.length > 0){
    for(var i=0; i < themes.length; i++)
      themes.options[i].selected=true;
  }
  return true;
}
