class AuthController < Devise::OmniauthCallbacksController 

  def google_oauth2
    auth = request.env["omniauth.auth"].info
    @user = User.find_by_email(auth.email)
    if !@user.nil?
      logger.info "Login con google: #{@user.email}"
      sign_in @user
      redirect_to root2_path 
    else
      logger.info "El login con google fallo porque el usuario no esta registrado en el sistema: #{auth}"
      flash[:notice] = "El usuario no tiene cuenta en el sitio."
      redirect_to new_user_session_url 
    end
  end


  def facebook
    auth = request.env["omniauth.auth"].info
    @user = User.find_by_email(auth.email)
    if !@user.nil?
      logger.info "Login con facebook: #{@user.email}"
      sign_in @user
      redirect_to root2_path 
    else
      logger.info "El login con facebook fallo porque el usuario no esta registrado en el sistema: #{auth}"
      flash[:notice] = "El usuario no tiene cuenta en el sitio."
      redirect_to new_user_session_url 
    end

  end

  def twitter
    auth = request.env["omniauth.auth"].info
    p params['oauth_token']
    uri = 'http://api.twitter.com/oauth/authorize?oauth_token=' + params['oauth_token'] + '&force_login=true'
    p uri
    result = URI.parse(URI.escape(uri))
    json = open(result).read
    p json
    p result
=begin
    consumer = OAuth::Consumer.new("dHnfZxanolf0ay64TtNg", "33dbk8mRnjp6UvvLDupOaqafc8kNu0gbCXTBBS1eXpo",
      { :site => "http://api.twitter.com",
        :scheme => :header
    })
    token_hash = {
      :oauth_token => "93132023-FttxuEbFeOdosuEseXElDpfOs52IHd9mqffUKwTlC",
      :oauth_token_secret => "ezheU9LnMIdi6alAS9c2cHsJCD6F6XhlvYSmXABtrBs"
    }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    res = access_token.request(:get, "http://api.twitter.com/1/statuses/home_timeline.json")
    p "RESSSSSSSSSSSSSSS: #{res.body}"
    p access_token
=end
  end

end
