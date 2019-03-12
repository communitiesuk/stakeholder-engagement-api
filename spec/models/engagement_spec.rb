require 'rails_helper'

describe Engagement do
  describe '#slug' do
    let(:engagement) { build(:engagement, id: 1234) }

    it 'returns the id' do
      expect(engagement.slug).to eq(engagement.id)
    end
  end
end
