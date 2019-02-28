require 'rails_helper'
require 'support/factory_bot'

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
        let(:perform_request) { get '/api/v1/organisation_types', headers: headers }
        it 'returns http success' do
          perform_request
          expect(response).to have_http_status(:success)
        end


        describe 'the response body' do
          let(:body) do
            perform_request
            response.body
          end
          let(:parsed_json) { JSON.parse(body) }

          it 'is JSON' do
            perform_request
            expect(response.content_type).to eq('application/vnd.api+json')
          end

          describe 'the JSON body' do
            it 'is valid ' do
              expect{ parsed_json }.to_not raise_error
            end

            it 'has jsonapi v1 statement' do
              expect(parsed_json['jsonapi']).to eq( {'version' => '1.0'} )
            end

            describe 'the data key' do
              let(:data) { parsed_json['data'] }

              it 'contains a JSON array' do
                expect(data).to be_a(Array)
              end

              describe 'the JSON array' do
                before do
                  create(:organisation_type)
                  create(:organisation_type, name: 'House builder')
                end

                it 'has an element for each OrganisationType' do
                  expect(data.length).to eq(2)
                end

                describe 'each element' do
                  it 'has jsonapi-compliant keys' do
                    data.each do |element|
                      expect(element.keys).to match_array(["attributes", "id", "links", "type"])
                    end
                  end
                  it 'has the attributes of an OrganisationType' do
                    data.each do |element|
                      expect(element['attributes'].keys).to match_array(OrganisationType.new.attributes.keys)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
