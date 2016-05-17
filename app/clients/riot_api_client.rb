require 'open-uri'

class RiotApiClient
  BASE_URL = 'https://na.api.pvp.net/api/lol/na'
  API_KEY = Rails.application.secrets.riot_api_key

  def fetch_summoner(summoner_id)
    response = HTTParty.get("#{BASE_URL}/v1.4/summoner/#{summoner_id}?api_key=#{API_KEY}")

    if response.code == 200
      JSON.parse(response.body)[summoner_id.to_s]
    else
      raise_http_error(response)
    end
  end

  # "old" match history is the game-v1.3 endpoint that includes all summoner ids
  def fetch_old_match_history(id)
    response = HTTParty.get("#{BASE_URL}/v1.3/game/by-summoner/#{id}/recent?api_key=#{API_KEY}")

    if response.code == 200
      JSON.parse(response.body)
    else
      raise_http_error(response)
    end
  end

  private

  def raise_http_error(response)
    raise OpenURI::HTTPError.new("#{response.code}: #{response.message}", nil)
  end
end
