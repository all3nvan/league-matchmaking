require 'rails_helper'

RSpec.describe GetNewInhouseMatchesJob, type: :job do
  include ActiveJob::TestHelper

  let(:player) { Player.create(name: 'all3nvan', summoner_id: 23472148) }

  describe '#perform' do
    it 'creates GetNewInhouseMatches for player and performs it' do
      get_new_inhouse_matches = instance_double(GetNewInhouseMatches)
      allow(GetNewInhouseMatches).
        to receive(:new).
        with(player).
        and_return(get_new_inhouse_matches)
      allow(get_new_inhouse_matches).to receive(:perform).and_return(nil)

      expect(GetNewInhouseMatches).to receive(:new).with(player)
      expect(get_new_inhouse_matches).to receive(:perform)

      GetNewInhouseMatchesJob.perform_now(player)
    end

    it 'requeues itself' do
      assert_enqueued_with(job: GetNewInhouseMatchesJob, args: [player]) do
        GetNewInhouseMatchesJob.perform_now(player)
      end
    end
  end
end
