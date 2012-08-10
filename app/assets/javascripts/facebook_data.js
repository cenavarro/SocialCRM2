function show(id){
  document.getElementById(id).style.visibility="visible";
  document.getElementById(id).style.display="block";
  document.getElementById('btnShow').style.display="none";
}
 
function hide(id){
  document.getElementById(id).style.visibility="hidden";
  document.getElementById(id).style.display="none";
  document.getElementById('btnShow').style.display="block";
}