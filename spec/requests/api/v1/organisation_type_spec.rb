require 'rails_helper'

describe Api::V1::OrganisationTypesController do
  let(:headers) { {} }

  context 'a JSON request' do
    let(:headers) {
      {
        "ACCEPT" => "application/json",     # This is what Rails 4 accepts
        "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
      }
    }
    context 'with no authentication' do
      describe 'GET #index' do
        before do
          get '/api/v1/organisation_types', headers: headers
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end


        describe 'the response body' do
          let(:body) { response.body }
          let(:parsed_json) { JSON.parse(body) }

          it 'contains valid JSON' do
            expect{ parsed_json }.to_not raise_error
          end

          it 'contains a JSON array' do
            expect(parsed_json).to be_a(Array)
          end

          describe 'the JSON array' do
            it 'has an element for each OrganisationType' do
              expect(parsed_json.length).to eq(OrganisationType.count)
            end

            describe 'each element' do
              it 'has the attributes of an OrganisationType' do
                parsed_json.each do |element|
                  expect(element.keys).to match_array(OrganisationType.attributes)
                end
              end
            end
          end
        end
      end
    end
  end
end
