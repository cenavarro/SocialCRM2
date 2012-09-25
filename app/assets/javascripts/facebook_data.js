function connectFacebook(IdClient,APP_ID,locale){
  protocol = location.protocol;
  hostname = location.host;
  start_date = document.getElementById('facebook_datum_start_date').value;
  end_date = document.getElementById('facebook_datum_end_date').value;
  var redirect_path = protocol+"//"+hostname+"/"+locale+"/facebook_data/callback/"+IdClient+"/"+start_date+"/"+end_date+"/?";
  var path = 'https://www.facebook.com/dialog/oauth?';
  var queryParams = ['client_id=' + APP_ID,
    'redirect_uri='+redirect_path,
    'response_type=code'];
  var query = queryParams.join('&');
  var url = path + query;
  window.location.href = url;
}

