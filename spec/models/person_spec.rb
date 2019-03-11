require 'rails_helper'
require 'support/factory_bot'

describe Person do
  context 'creating a Person' do
    context 'when the same name already exists' do
      let!(:existing_person) { create(:person, title: 'Mr', name: 'John Smith') }
      let(:new_person) { create(:person, title: 'Mr', name: 'John Smith') }

      it 'saves with no errors' do
        expect { new_person }.to_not raise_error
      end

      it 'makes a unique slug' do
        expect(new_person.slug).to_not eq(existing_person.slug)
      end
    end
  end
end
