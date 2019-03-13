require 'rails_helper'

describe SortParam do

  describe '#to_activerecord_order_clause' do
    let(:result) { subject.to_activerecord_order_clause }
    let(:root_class) { Engagement }
    subject { described_class.new(as_given: param, root_class: root_class) }

    context 'given a simple param with no hyphen or scope' do
      let(:param) { 'name' }

      describe 'the result' do
        describe 'the result' do
          it 'is the param value' do
            expect(result).to eq('name')
          end
        end
      end
    end

    context 'when the param starts with a hyphen' do
      let(:param) { '-name' }
      describe 'the result' do
        it 'is the param value followed by DESC' do
          expect(result).to eq('name DESC')
        end
      end
    end

    context 'when the param contains an association and a .' do
      let(:param) { 'stakeholder.name' }

      it 'replaces the association with the table_name' do
        expect(result).to eq('people.name')
      end
    end
  end

end
