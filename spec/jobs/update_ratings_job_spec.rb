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

  describe '#teams' do
    it 'separates players into teams' do
      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)
        inhouse_match = inhouse_matches.last

        expected = {
          blue_team: [21740765, 32935590, 19808433, 38833769, 23472148],
          red_team: [34623703, 22004927, 37437842, 38268599, 43506536]
        }

        teams = job.send(:teams, inhouse_match)

        expect(teams[:blue_team]).to eq(expected[:blue_team])
        expect(teams[:red_team]).to eq(expected[:red_team])
      end
    end
  end
end
