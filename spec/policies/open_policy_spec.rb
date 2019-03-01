require 'rails_helper'

describe OpenPolicy do
  let(:user) { nil }
  let(:record) { nil }
  subject do
    described_class.new(user, record)
  end

  describe '#index?' do
    it 'is true' do
      expect(subject.index?).to eq(true)
    end
  end

  describe '#show?' do
    it 'is true' do
      expect(subject.show?).to eq(true)
    end
  end

  describe '#update?' do
    it 'is true' do
      expect(subject.update?).to eq(true)
    end
  end

  describe '#destroy?' do
    it 'is true' do
      expect(subject.destroy?).to eq(true)
    end
  end

  describe '#create?' do
    it 'is true' do
      expect(subject.create?).to eq(true)
    end
  end
end
