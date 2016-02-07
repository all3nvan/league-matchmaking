require 'TrueSkill'

class Player < ActiveRecord::Base
  validates :name, presence: true
  validates :summoner_id, presence: true

  before_create :set_default_rating

  def wins
    MatchPlayer.where(player_id: self.id, win: true).count
  end

  def losses
    MatchPlayer.where(player_id: self.id, win: false).count
  end

  def trueskill
    self.rating - 3 * self.standard_deviation
  end

  def champion_stats
    player_matches = MatchPlayer.where(player_id: self.id)
    champion_ids = player_matches
      .group(:champion_id)
      .count
      .keys

    stats = champion_ids.map do |champion_id|
      champion_matches = player_matches.where(champion_id: champion_id)
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

  private

  def set_default_rating
    rating = Rating.new

    self.rating = rating.mu
    self.standard_deviation = rating.sigma
  end
end
