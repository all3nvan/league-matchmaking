class UpdateRatingsJob < ActiveJob::Base
  queue_as :default

  riot_api = RiotApi.new

  def perform(*args)
    # Do something later
  end
end
