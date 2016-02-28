class Champion
  # Player::champion_stats has same logic. need to refactor
  def all_champion_stats
    champion_ids = MatchPlayer
      .group(:champion_id)
      .count
      .keys

    stats = champion_ids.map do |champion_id|
      champion_matches = MatchPlayer.where(champion_id: champion_id)
      champion_wins = champion_matches.where(win: true).count
      champion_losses = champion_matches.where(win: false).count
      {
        id: champion_id,
        wins: champion_wins,
        losses: champion_losses,
        winrate: (champion_wins.to_f / (champion_wins + champion_losses) * 100).round(2)
      }
    end

    stats.sort_by { |stat| [stat[:winrate], stat[:wins]] }.reverse
  end
end
