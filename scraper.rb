require 'bundler/setup'
require 'scraperwiki'
require 'twitter'
require 'pry'
require 'dotenv'

Dotenv.load

def twitter
  @twitter ||= Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['MORPH_TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['MORPH_TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV['MORPH_TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['MORPH_TWITTER_ACCESS_TOKEN_SECRET']
  end
end

# account Mx_Diputados (Cuenta oficial de la Cámara de Diputados)
# follows members of the Mexican chamber of deputies
# https://twitter.com/Mx_Diputados/following

twitter.friends('Mx_Diputados').each do |person|
  data = {
    id: person.id,
    name: person.name,
    twitter: person.screen_name,
  }
  data[:image] = person.profile_image_url_https(:original).to_s unless person.default_profile_image?
  ScraperWiki.save_sqlite([:id], data)
end
