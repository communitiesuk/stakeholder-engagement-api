require 'rails_helper'

describe Api::V1::ApiHelper do
  describe '.to_activerecord_order_clause' do
    let(:result) { helper.to_activerecord_order_clause(param) }

    context 'given nil' do
      let(:param) {}
      it 'returns nil' do
        expect(result).to eq(nil)
      end
    end

    context 'given a single sort param' do
      let(:param) { 'name' }

      describe 'the result' do
        it 'is an array' do
          expect(result).to be_a(Array)
        end

        it 'has one element' do
          expect( result.size ).to eq(1)
        end

        describe 'the only element' do
          it 'is the param value' do
            expect(result[0]).to eq('name')
          end
        end
      end

      context 'that starts with a hyphen' do
        let(:param) { '-name' }
        describe 'the result' do
          it 'is the param value followed by DESC' do
            expect(result[0]).to eq('name DESC')
          end
        end
      end
    end
    context 'given multiple sort params' do
      let(:param) { 'name,-age' }

      describe 'the result' do
        it 'is an array' do
          expect(result).to be_a(Array)
        end

        it 'has the same number of elements as the sort param' do
          expect( result.size ).to eq(2)
        end

        describe 'a param which does not start with a hyphen' do
          it 'is the param value' do
            expect(result[0]).to eq('name')
          end
        end
        describe 'a params which starts with a hyphen' do
          it 'is the param value followed by DESC' do
            expect(result[1]).to eq('age DESC')
          end
        end
      end
    end
  end

  describe '.to_limit' do
    let(:result) { helper.to_limit(params) }
    let(:params) { {} }

    context 'given params including page[limit]' do
      let(:params) { {'page[limit]' => '7'} }

      it 'returns the page[limit] param as an integer' do
        expect(result).to eq(7)
      end
    end

    context 'given params including page[size]' do
      let(:params) { {'page[size]' => '7'} }

      it 'returns the page[size] param as an integer' do
        expect(result).to eq(7)
      end
    end

    context 'given params that do not include page[limit] or page[size]' do
      let(:params) { {'foo' => 'bar'} }
      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end

  describe '.to_offset' do
    let(:result) { helper.to_offset(params) }
    let(:params) { {} }

    context 'given params including page[offset]' do
      let(:params) { {'page[offset]' => '7'} }

      it 'returns the page[offset] param as an integer' do
        expect(result).to eq(7)
      end
    end

    context 'given params including page[size] and page[number]' do
      let(:params) { {'page[size]' => '10', 'page[number]' => '2'} }

      it 'returns the (page[size] - 1) * page[number]' do
        expect(result).to eq(10)
      end
    end

    context 'given params that do not include page[limit] or page[size]' do
      let(:params) { {'foo' => 'bar'} }
      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end
