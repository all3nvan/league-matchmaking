module MatchmakingHelper
  def create_teams(selected_player_ids)
    best_match(selected_player_ids).map do |team|
      team.map { |player_id| Player.find(player_id) }
    end
  end

  private

  def best_match(selected_player_ids)
    team_combos(selected_player_ids).max_by { |team_combo| match_quality(team_combo) }
  end

  def team_combos(selected_player_ids)
    team_1 = selected_player_ids.combination(5).to_a
    team_2 = team_1.map do |team|
      selected_player_ids.reject { |id| team.include?(id) }
    end

    (0..team_1.length - 1).map do |i|
      [team_1[i], team_2[i]]
    end
  end

  def match_quality(team_combo)
    teams_ratings = team_combo.map do |team|
      team.map do |player_id|
        player = Player.find(player_id)
        Rating.new(player.rating, player.standard_deviation)
      end
    end

    g().match_quality(teams_ratings)
  end
end
