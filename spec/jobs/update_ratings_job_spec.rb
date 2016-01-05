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
    it 'separates players into teams when tracked player is on blue team' do
      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)
        # this might change if recorded match history response changes
        inhouse_match = inhouse_matches.last

        expected = {
          100 => [23472148, 21740765, 32935590, 19808433, 38833769],
          200 => [34623703, 22004927, 37437842, 38268599, 43506536]
        }

        expect(job.send(:teams, inhouse_match)).to eq(expected)
      end
    end

    it 'separates players into teams when tracked player is on red team' do
      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)
        # this might change if recorded match history response changes
        inhouse_match = inhouse_matches.select { |match| match['gameId'] == 2056989128 }.first

        expected = {
          100 => [42731486, 38060496, 37437842, 22122936, 19658154],
          200 => [23472148, 24822050, 19808433, 38833769, 19306933]
        }

        expect(job.send(:teams, inhouse_match)).to eq(expected)
      end
    end
  end

  describe '#determine_winner' do
    it 'is 100 when tracked player is on blue team and wins' do
      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)
        # this might change if recorded match history response changes
        inhouse_match = inhouse_matches.select { |match| match['gameId'] == 2055912296 }.first

        expect(job.send(:determine_winner, inhouse_match)).to eq(100)
      end
    end

    it 'is 200 when tracked player is on red team and wins' do
      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)
        # this might change if recorded match history response changes
        inhouse_match = inhouse_matches.select { |match| match['gameId'] == 2056823635 }.first

        expect(job.send(:determine_winner, inhouse_match)).to eq(200)
      end
    end

    it 'is 200 when tracked player is on blue team and loses' do
      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)
        # this might change if recorded match history response changes
        inhouse_match = inhouse_matches.select { |match| match['gameId'] == 2056823959 }.first

        expect(job.send(:determine_winner, inhouse_match)).to eq(200)
      end
    end

    it 'is 100 when tracked player is on red team and loses' do
      VCR.use_cassette('old_match_history') do
        inhouse_matches = job.send(:new_inhouse_matches)
        # this might change if recorded match history response changes
        inhouse_match = inhouse_matches.select { |match| match['gameId'] == 2056989128 }.first

        expect(job.send(:determine_winner, inhouse_match)).to eq(100)
      end
    end
  end

  describe '#team_players' do
    it 'transforms summoner ids to player objects' do
      team_summoner_ids = { 100 => [100, 101, 102, 103, 104], 200 => [20, 19, 18, 17, 16] }
      expected = {
        100 => [
          Player.create(name: 'a', summoner_id: 100),
          Player.create(name: 'a', summoner_id: 101),
          Player.create(name: 'a', summoner_id: 102),
          Player.create(name: 'a', summoner_id: 103),
          Player.create(name: 'a', summoner_id: 104)
        ],
        200 => [
          Player.create(name: 'a', summoner_id: 20),
          Player.create(name: 'a', summoner_id: 19),
          Player.create(name: 'a', summoner_id: 18),
          Player.create(name: 'a', summoner_id: 17),
          Player.create(name: 'a', summoner_id: 16)
        ]
      }

      expect(job.send(:team_players, team_summoner_ids)).to eq(expected)
    end
  end
end
