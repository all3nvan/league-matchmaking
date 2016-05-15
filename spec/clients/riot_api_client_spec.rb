require 'rails_helper'

RSpec.describe RiotApiClient, type: :client do
  let(:riot_api_client) { instance_double("RiotApiClient") }

  describe '#summoner_by_id' do
    let(:summoner_id) { 23472148 }

    context 'when successful' do
      it 'returns summoner info' do
        allow(riot_api_client).to receive(:summoner_by_id).
          with(summoner_id).
          and_return({
            "id": 23472148,
            "name": "all3nvan",
            "profileIconId": 917,
            "revisionDate": 1463290322000,
            "summonerLevel": 30
          })

        response = riot_api_client.summoner_by_id(summoner_id)
        expect(response[:id]).to eq(summoner_id)
      end
    end

    context 'when unsuccessful' do
      it 'raises exception' do
        allow(riot_api_client).to receive(:summoner_by_id).
          and_raise(OpenURI::HTTPError.new('bad response', nil))
        expect { riot_api_client.summoner_by_id(summoner_id) }.
          to raise_exception(OpenURI::HTTPError)
      end
    end
  end
end
