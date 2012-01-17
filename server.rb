require './oauth_helper'

$KCODE = 'u'

include OAuthHelper

set :oauth_consumer_key, ENV['OAUTH_CONSUMER_KEY']
set :oauth_consumer_secret, ENV['OAUTH_CONSUMER_SECRET']
set :oauth_site, 'https://api.twitter.com/'
set :oauth_redirect_to, '/welcome'

get '/' do
  haml :index
end

get '/welcome' do
  haml :welcome
end

get '/update' do
  status = params[:status] || ''
  access_token_key = session[:access_token_key]
  access_token_secret = session[:access_token_secret]
  access_token = OAuth::AccessToken.new(oauth_consumer, access_token_key, access_token_secret)

  Twitter.configure do |config|
    config.consumer_key = settings.oauth_consumer_key
    config.consumer_secret = settings.oauth_consumer_secret
    config.oauth_token = access_token_key
    config.oauth_token_secret = access_token_secret
  end
  twitter = Twitter::Client.new

  status.split(//).each do |c|
    paddings = (0...130).to_a.map { [0x200b, 0x200c].sort_by { rand }.first }
    twitter.update c + ' ' + paddings.pack('U*') + ''
  end

  haml :updated
end
