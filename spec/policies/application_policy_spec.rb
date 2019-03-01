require 'rails_helper'

describe ApplicationPolicy do
  let(:user) { nil }
  let(:record) { nil }
  subject do
    described_class.new(user, record)
  end

  describe '#index?' do
    it 'is false' do
      expect(subject.index?).to eq(false)
    end
  end

  describe '#show?' do
    it 'is false' do
      expect(subject.show?).to eq(false)
    end
  end

  describe '#edit?' do
    it 'is false' do
      expect(subject.edit?).to eq(false)
    end
  end

  describe '#update?' do
    it 'is false' do
      expect(subject.update?).to eq(false)
    end
  end

  describe '#destroy?' do
    it 'is false' do
      expect(subject.destroy?).to eq(false)
    end
  end

  describe '#new?' do
    it 'is false' do
      expect(subject.new?).to eq(false)
    end
  end

  describe '#create?' do
    it 'is false' do
      expect(subject.create?).to eq(false)
    end
  end

  describe ApplicationPolicy::Scope do
    let(:scope) { double('scope', all: 'mock all') }
    subject do
      described_class.new(user, scope)
    end
    describe 'creating a new scope' do

      it 'stores the given user' do
        expect(subject.user).to eq(user)
      end
      it 'stores the given scope' do
        expect(subject.scope).to eq(scope)
      end
    end

    describe '.resolve' do
      it 'returns scope.all' do
        expect(subject.resolve).to eq('mock all')
      end
    end
  end
end
