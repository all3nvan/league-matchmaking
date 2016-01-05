class UpdateRatingsJob < ActiveJob::Base
  queue_as :default

  def initialize(player)
    super
    @riot_api = RiotApi.new
    @player = player
    @num_of_requests = 10
  end

  def perform
    new_inhouse_matches.each do |inhouse_match|
      match = create_match(inhouse_match)
      teams = teams(inhouse_match)
      winning_team_id = determine_winner(inhouse_match)

      MatchPlayer.create(
        player: @player, match: match, champion_id: inhouse_match['championId'],
        win: inhouse_match['stats']['win']
      )

      inhouse_match['fellowPlayers'].each do |fellow_player|
        fellow_player_id = fellow_player['summonerId']
        player = Player.find_by(summoner_id: fellow_player_id) || create_player(fellow_player_id)
        win = fellow_player['teamId'] == winning_team_id
        MatchPlayer.create(
          player: player, match: match, champion_id: fellow_player['championId'], win: win
        )
      end

      update_ratings(teams, winning_team_id)

      self.class.set(wait: 30.min).perform_later
    end
  end

  private

  def rate_limit
    @num_of_requests += 1
    if @num_of_requests >= 10
      sleep(11)
      @num_of_requests = 0
    end
  end

  # tested
  def new_inhouse_matches
    rate_limit

    @riot_api.old_match_history(@player.summoner_id).select do |match|
      match['gameType'] == 'CUSTOM_GAME' && !Match.exists?(match_id: match['gameId'])
    end
  end

  def create_match(inhouse_match)
    Match.create(match_id: inhouse_match['gameId'], time: inhouse_match['createDate'] / 1000)
  end

  def create_player(id)
    rate_limit

    player = @riot_api.summoner_by_id(id)
    Player.create(name: player['name'], summoner_id: player['id'])
  end

  # tested
  def teams(inhouse_match)
    initial_team = { inhouse_match['teamId'] => [@player.summoner_id] }

    inhouse_match['fellowPlayers'].each_with_object(initial_team) do |fellow_player, teams_hash|
      teams_hash[fellow_player['teamId']] = [] unless teams_hash.key?(fellow_player['teamId'])
      teams_hash[fellow_player['teamId']].push(fellow_player['summonerId'])
    end
  end

  # tested
  def determine_winner(inhouse_match)
    return inhouse_match['stats']['team'] if inhouse_match['stats']['win']

    # the tracked player lost
    if inhouse_match['stats']['team'] == 100
      200
    else
      100
    end
  end

  # params
  # teams = { 100: [summoner_ids], 200: [summoner_ids] }
  def update_ratings(teams, winning_team_id)
    team_id_to_players = team_players(teams)
    team_id_to_ratings = team_ratings(team_id_to_players)

    blue_team_win = winning_team_id == 100 ? 0 : 1
    red_team_win = winning_team_id == 200 ? 0 : 1

    new_ratings = g().transform_ratings(
      [team_id_to_ratings[100], team_id_to_ratings[200]], [blue_team_win, red_team_win]
    )

    update_player_ratings(team_id_to_players, new_ratings)
  end

  # tested
  # params
  # teams = { 100: [summoner_ids], 200: [summoner_ids] }
  def team_players(teams)
    blue_team_players = teams[100].map { |id| Player.find_by(summoner_id: id) }
    red_team_players = teams[200].map { |id| Player.find_by(summoner_id: id) }

    { 100 => blue_team_players, 200 => red_team_players }
  end

  # params
  # teams = { 100: [Players], 200: [Players] }
  def team_ratings(teams)
    blue_team_ratings = teams[100].map do |player|
      Rating.new(player.rating, player.standard_deviation)
    end

    red_team_ratings = teams[200].map do |player|
      Rating.new(player.rating, player.standard_deviation)
    end

    { 100 => blue_team_ratings, 200 => red_team_ratings }
  end

  # params
  # teams = { 100: [Players], 200: [Players] }
  # ratings = [ [Ratings], [Ratings] ]
  def update_player_ratings(teams, ratings)
    new_blue_team_ratings = ratings[0]
    new_red_team_ratings = ratings[1]

    teams[100].each.with_index do |player, i|
      new_rating = new_blue_team_ratings[i]
      player.update(rating: new_rating.mu, standard_deviation: new_rating.sigma)
    end

    teams[200].each.with_index do |player, i|
      new_rating = new_red_team_ratings[i]
      player.update(rating: new_rating.mu, standard_deviation: new_rating.sigma)
    end
  end
end
