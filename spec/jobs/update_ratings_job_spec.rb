require 'rails_helper'

RSpec.describe UpdateRatingsJob, type: :job do
  let(:player) { Player.create(name: 'all3nvan', summoner_id: 23472148) }
  let(:job) { UpdateRatingsJob.new(player) }

  describe '#new_inhouse_matches' do
    it 'selects inhouse matches from match history' do
      expected_match_ids = [2056989128, 2056988616, 2056823959, 2056823635, 2056823072,
                            2055912851, 2055912296]

      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)

        expected_match_ids.each_index do |i|
          expect(inhouse_matches[i]['gameId']).to eq(expected_match_ids[i])
        end

        expect(inhouse_matches.size).to eq(expected_match_ids.size)
      end
    end
  end
end
