require 'rails_helper'

RSpec.describe RiotApiClient, type: :client do
  let(:riot_api_client) { RiotApiClient.new }
  let(:summoner_id) { 23472148 }

  describe '#fetch_summoner' do
    let(:fetch_summoner_url) {
      "#{RiotApiClient::BASE_URL}/v1.4/summoner/#{summoner_id}?api_key=#{RiotApiClient::API_KEY}"
    }

    context 'when successful' do
      it 'returns summoner info' do
        stub_request(:get, fetch_summoner_url).
          to_return(
            body: File.read('./spec/api_responses/summoner.json'),
            status: 200)

        response = riot_api_client.fetch_summoner(summoner_id)

        expect(response['id']).to eq(summoner_id)
        expect(response['name']).to eq('all3nvan')
      end
    end

    context 'when unsuccessful' do
      it 'raises exception' do
        stub_request(:get, fetch_summoner_url).to_return(status: [429, 'Rate limit exceeded'])

        expect { riot_api_client.fetch_summoner(summoner_id) }.to raise_error(OpenURI::HTTPError)
      end
    end
  end

  describe '#fetch_old_match_history' do
    let(:fetch_old_match_history_url) {
      "#{RiotApiClient::BASE_URL}/v1.3/game/by-summoner/#{summoner_id}/recent?api_key=#{RiotApiClient::API_KEY}"
    }

    context 'when successful' do
      it 'returns match history' do
        stub_request(:get, fetch_old_match_history_url).
          to_return(
            body: File.read('./spec/api_responses/old_match_history.json'),
            status: 200)

        response = riot_api_client.fetch_old_match_history(summoner_id)

        expect(response['summonerId']).to eq(summoner_id)
        expect(response['games']).to be_an_instance_of(Array)
      end
    end

    context 'when unsuccessful' do
      it 'raises exception' do
        stub_request(:get, fetch_old_match_history_url).
          to_return(status: [429, 'Rate limit exceeded'])

        expect { riot_api_client.fetch_old_match_history(summoner_id) }.
          to raise_exception(OpenURI::HTTPError)
      end
    end
  end
end
