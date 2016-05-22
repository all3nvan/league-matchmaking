class GetNewInhouseMatches
  def initialize(player)
    @riot_api_client = RiotApiClient.new
    @player = player
  end

  def perform
    new_inhouse_matches.each do |match|
      Match.create(
        match_id: match[RiotApiKeys::GAME_ID],
        time: match[RiotApiKeys::CREATE_DATE] / 1000
      )
    end
  end

  private

  def matches
    @riot_api_client.fetch_old_match_history(@player.summoner_id)[RiotApiKeys::GAMES]
  end

  def new_inhouse_matches
    matches.select do |match|
      match[RiotApiKeys::GAME_TYPE] == 'CUSTOM_GAME' &&
        !Match.exists?(match_id: match[RiotApiKeys::GAME_ID]) &&
        !match[RiotApiKeys::FELLOW_PLAYERS].nil? &&
        match[RiotApiKeys::FELLOW_PLAYERS].size == 9
    end
  end
end
