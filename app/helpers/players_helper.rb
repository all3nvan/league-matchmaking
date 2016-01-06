module PlayersHelper
  def players_by_rank(players)
    players.sort { |a, b| b.trueskill <=> a.trueskill }
  end
end
