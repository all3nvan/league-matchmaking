class Player < ActiveRecord::Base
  validates :name, presence: true
  validates :summoner_id, presence: true
end
