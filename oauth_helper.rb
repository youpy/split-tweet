module OAuthHelper
  enable :sessions

  get '/oauth/auth' do
    request_token = oauth_consumer.get_request_token(:oauth_callback => url('/oauth/cb'))
    session[:request_token] = request_token
    redirect request_token.authorize_url
  end

  get '/oauth/cb' do
    access_token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:access_token_key] = access_token.token
    session[:access_token_secret] = access_token.secret
    session.delete(:request_token)
    redirect to(settings.oauth_redirect_to)
  end

  def oauth_consumer
    OAuth::Consumer.new(
      settings.oauth_consumer_key,
      settings.oauth_consumer_secret,
      {
        :site => settings.oauth_site,
      })
  end
end
