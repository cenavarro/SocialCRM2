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
  protocol = location.protocol;
  hostname = location.host;
  start_date = document.getElementById('facebook_datum_start_date').value;
  end_date = document.getElementById('facebook_datum_end_date').value;
  var redirect_path = protocol+"//"+hostname+"/facebook_data/callback/"+IdClient+"/"+start_date+"/"+end_date+"/?";
  var path = 'https://www.facebook.com/dialog/oauth?';
  var queryParams = ['client_id=' + APP_ID,
    'redirect_uri='+redirect_path,
    'response_type=code'];
  var query = queryParams.join('&');
  var url = path + query;
  window.location.href = url;
}
