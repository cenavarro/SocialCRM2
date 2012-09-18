function loginFacebook(APP_ID,Page){
    protocol = location.protocol;
      hostname = location.host;
        redirect_url = protocol+"//"+hostname+"/"+Page+"/";
          url = "https://www.facebook.com/dialog/oauth?client_id="+APP_ID+"&redirect_uri="+redirect_url+"&response_type=code&display=page&scope=email,manage_pages,read_insights,ads_management";
            window.location = encodeURI(url);
}
