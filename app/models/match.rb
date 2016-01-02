class Match < ActiveRecord::Base
  validates :match_id, presence: true
  validates :time, presence: true
end
