require 'TrueSkill'

class Player < ActiveRecord::Base
  validates :name, presence: true
  validates :summoner_id, presence: true

  before_create :set_default_rating

  private

  def set_default_rating
    rating = Rating.new

    self.rating = rating.mu
    self.standard_deviation = rating.sigma
  end
end
