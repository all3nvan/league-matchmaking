require 'rails_helper'

RSpec.describe GetNewInhouseMatches, type: :updaters do
  let(:player) { Player.find_or_create_by(name: 'edzwoo', summoner_id: 38049106) }
  let(:get_new_inhouse_matches) { GetNewInhouseMatches.new(player) }

  describe '#perform' do
    it 'creates Match records for new inhouse matches' do
      old_match_history_body = JSON.parse(
          File.read('./spec/api_responses/old_match_history_with_bot_game.json')
      )
      allow_any_instance_of(RiotApiClient).
        to receive(:fetch_old_match_history).
        with(player.summoner_id).
        and_return(old_match_history_body)
      # Create record using one of the matches in the api response to test that
      # matches don't get duplicated
      Match.create(match_id: 2054191715, time: 1451552521345 / 1000)

      get_new_inhouse_matches.perform

      expect(Match.where(match_id: 2058246032, time: 1451975763925 / 1000)).to exist
      expect(Match.where(match_id: 2058474674, time: 1451972056058 / 1000)).to exist
      expect(Match.where(match_id: 2056823959, time: 1451811157519 / 1000)).to exist
      expect(Match.where(match_id: 2056823635, time: 1451806833384 / 1000)).to exist
      expect(Match.where(match_id: 2056823072, time: 1451803710424 / 1000)).to exist
      expect(Match.count).to eq(6)
    end
  end
end
