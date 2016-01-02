require 'rails_helper'

RSpec.describe Match, type: :model do
  describe '#attributes' do
    match = Match.new

    it 'has a match id' do
      expect(match).to_not be_valid
      expect(match.errors.keys).to include :match_id
    end

    it 'has a time' do
      expect(match).to_not be_valid
      expect(match.errors.keys).to include :time
    end
  end
end
