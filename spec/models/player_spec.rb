require 'rails_helper'

RSpec.describe Player, type: :model do
  describe '#attributes' do
    player = Player.new

    it 'has a name' do
      expect(player).to_not be_valid
      expect(player.errors.keys).to include :name
    end

    it 'has a summoner_id' do
      expect(player).to_not be_valid
      expect(player.errors.keys).to include :summoner_id
    end
  end
end
