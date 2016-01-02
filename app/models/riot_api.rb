require 'open-uri'

class RiotApi
  BASE_URL = 'https://na.api.pvp.net/api/lol/na'
  API_KEY = Rails.application.secrets.riot_api_key

  def summoner_by_id(id)
    response = JSON.parse(OpenURI.open_uri("#{BASE_URL}/v1.4/summoner/#{id}?api_key=#{API_KEY}").read)
    response[id.to_s]
  end
end