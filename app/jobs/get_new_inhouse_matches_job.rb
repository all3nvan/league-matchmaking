class GetNewInhouseMatchesJob < ActiveJob::Base
  queue_as :default

  def perform(player)
    GetNewInhouseMatches.new(player).perform
    self.class.set(wait: 5.minutes).perform_later(player)
  end
end
