function loginFacebook(){
  window.location = encodeURI("https://www.facebook.com/dialog/oauth?client_id=441436639234798&redirect_uri=http://localhost:3000/validate_user/&response_type=code&display=page");
}
