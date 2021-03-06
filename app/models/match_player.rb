class MatchPlayer < ActiveRecord::Base
  belongs_to :player
  belongs_to :match

  validates :player_id, presence: true
  validates :champion_id, presence: true
  validates :match_id, presence: true
end
