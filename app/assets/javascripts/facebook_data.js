function show(id,button){
  document.getElementById(id).style.visibility="visible";
  document.getElementById(id).style.display="block";
  document.getElementById(button).style.visibility="hidden";
  document.getElementById(button).style.display="none";
}
 
function hide(id,button){
  document.getElementById(id).style.visibility="hidden";
  document.getElementById(id).style.display="none";
  document.getElementById(button).style.visibility="visible";
  document.getElementById(button).style.display="block";
}