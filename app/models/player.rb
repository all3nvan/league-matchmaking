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

  private

  def set_default_rating
    rating = Rating.new

    self.rating = rating.mu
    self.standard_deviation = rating.sigma
  end
end
