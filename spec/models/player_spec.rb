require 'rails_helper'

RSpec.describe Player, type: :model do
  before(:all) do
    @player = Player.create(name: 'asdf', summoner_id: 123)
    MatchPlayer.create(player: @player, champion_id: 10, match_id: 1, win: true)
    MatchPlayer.create(player: @player, champion_id: 11, match_id: 2, win: true)
    MatchPlayer.create(player: @player, champion_id: 12, match_id: 3, win: false)
    MatchPlayer.create(player: @player, champion_id: 13, match_id: 4, win: true)
  end

  describe '#attributes' do
    invalid_player = Player.new
    rating = Rating.new

    it 'has a name' do
      expect(invalid_player).to_not be_valid
      expect(invalid_player.errors.keys).to include :name
    end

    it 'has a summoner_id' do
      expect(invalid_player).to_not be_valid
      expect(invalid_player.errors.keys).to include :summoner_id
    end

    describe 'trueskill ratings' do
      valid_player = Player.create(name: 'ayy', summoner_id: 1)

      it 'has trueskill-ranked default rating' do
        expect(valid_player.rating).to equal(rating.mu)
      end

      it 'has trueskill-ranked standard deviation' do
        expect(valid_player.standard_deviation).to equal(rating.sigma)
      end
    end
  end

  describe '#wins' do
    it 'returns number of wins' do
      expect(@player.wins).to eq(3)
    end
  end

  describe '#losses' do
    it 'returns number of losses' do
      expect(@player.losses).to eq(1)
    end
  end
end
