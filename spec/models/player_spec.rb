require 'rails_helper'

RSpec.describe Player, type: :model do
  describe '#attributes' do
    player = Player.new
    rating = Rating.new

    it 'has a name' do
      expect(player).to_not be_valid
      expect(player.errors.keys).to include :name
    end

    it 'has a summoner_id' do
      expect(player).to_not be_valid
      expect(player.errors.keys).to include :summoner_id
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
end
