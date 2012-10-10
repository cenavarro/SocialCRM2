function addNewChannel(){
  var htmlSelect = document.getElementById('channels_');
  var optionValue = document.getElementById('newOption');
  if (optionValue.value != ''){
    var selectBoxOption = document.createElement("option");
    selectBoxOption.value = optionValue.value;
    selectBoxOption.text = optionValue.value;
    htmlSelect.add(selectBoxOption, null);
    optionValue.value = '';
    return true;
  }
  alert("El canal no puede ser vacio!");
  return false;
}

function removeChannel(){
  var htmlSelect = document.getElementById('channels_');
  if (htmlSelect.options.length != 0){
    var optionToRemove = htmlSelect.options.selectedIndex;
    htmlSelect.remove(optionToRemove);
    if(htmlSelect.options.length > 0){
      htmlSelect.options[0].selected = true;
    }
    return true;
  }
  alert("No hay mas elementos por eliminar!");
  return false;
}

function selectAllChannelItems(){
  var htmlListBox = document.getElementById('channels_');
  if(htmlListBox.options.length > 0){
    for( var i=0; i < htmlListBox.length; i++)
      htmlListBox.options[i].selected=true;
  }
  return true;
}
