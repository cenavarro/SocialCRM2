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

function connectFacebook(IdClient,APP_ID){
  var redirect_path = "http://localhost:3000/facebook_data/callback/"+IdClient+"/"+document.getElementById('facebook_datum_start_date').value;
  redirect_path = redirect_path.concat('/'+document.getElementById('facebook_datum_end_date').value+"/?");
  var appID = 441436639234798;
  var path = 'https://www.facebook.com/dialog/oauth?';
  var queryParams = ['client_id=' + appID,
    'redirect_uri='+redirect_path,
    'response_type=code'];
  var query = queryParams.join('&');
  var url = path + query;
  window.location.href = url;
}
