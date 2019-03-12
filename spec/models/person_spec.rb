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

  context 'when a person has roles' do
    let(:role_1) { build(:role, title: 'Chief Executive') }
    let(:role_2) { build(:role, title: 'Head of Personnel') }

    before do
      subject.roles << role_1
      subject.roles << role_2
    end

    describe '#role_titles' do
      it 'returns an array of all the role titles' do
        expect(subject.role_titles).to eq(['Chief Executive', 'Head of Personnel'])
      end
    end

    context '#organisation_names' do
      let(:org_1) { build(:organisation, name: 'ACME Construction') }
      let(:org_2) { build(:organisation, name: 'Barraclough Leisure') }

      before do
        role_1.organisation = org_1
        role_2.organisation = org_2
      end

      it 'returns the names of the organisations in which they have roles' do
        expect(subject.organisation_names).to eq(['ACME Construction', 'Barraclough Leisure'])
      end
    end
  end
end
