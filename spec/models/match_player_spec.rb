require 'rails_helper'

RSpec.describe MatchPlayer, type: :model do
  describe '#attributes' do
    match_player = MatchPlayer.new

    it 'has a player id' do
      expect(match_player).to_not be_valid
      expect(match_player.errors.keys).to include :player_id
    end

    it 'has a champion id' do
      expect(match_player).to_not be_valid
      expect(match_player.errors.keys).to include :champion_id
    end

    it 'has a match id' do
      expect(match_player).to_not be_valid
      expect(match_player.errors.keys).to include :match_id
    end
  end
end
