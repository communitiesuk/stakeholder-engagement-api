require 'rails_helper'
require 'support/factory_bot'

describe Api::V1::OrganisationTypesController do
  let(:headers) { {} }
  let(:params) { {} }

  context 'a JSON request' do
    let(:headers) {
      {
        "ACCEPT" => "application/json",     # This is what Rails 4 accepts
        "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
      }
    }
    context 'with no authentication' do
      describe 'GET #show with ID' do
        let(:perform_request) { get "/api/v1/organisation_types/#{requested_id}", params: params, headers: headers }

        let(:organisation_type) do
          create(:organisation_type, name: 'Local Authority')
        end

        context 'when the requested entity does not exist' do
          let(:requested_id) { organisation_type.id + 1 }

          it 'returns http not found' do
            perform_request
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'when the requested entity exists' do
          let(:requested_id) { organisation_type.id }

          it 'returns http success' do
            perform_request
            expect(response).to have_http_status(:success)
          end

          describe 'the response body' do
            it 'is JSON' do
              perform_request
              expect(response.content_type).to eq('application/vnd.api+json')
            end

            describe 'the JSON body' do
              let(:body) do
                perform_request
                response.body
              end
              let(:parsed_json) { JSON.parse(body) }
              let(:data) { parsed_json['data'] }


              it 'is valid ' do
                expect{ parsed_json }.to_not raise_error
              end

              it 'has jsonapi-compliant keys' do
                expect(data.keys).to match_array(["attributes", "id", "links", "type"])
              end

              it 'has the attributes of an OrganisationType' do
                expect(data['attributes'].keys).to match_array(OrganisationType.new.attributes.keys)
              end
            end
          end
        end
      end

      describe 'GET #index' do
        let(:perform_request) { get '/api/v1/organisation_types', params: params, headers: headers }
        it 'returns http success' do
          perform_request
          expect(response).to have_http_status(:success)
        end


        describe 'the response body' do
          let(:body) do
            perform_request
            response.body
          end
          it 'is JSON' do
            perform_request
            expect(response.content_type).to eq('application/vnd.api+json')
          end

          describe 'the JSON body' do
            let(:parsed_json) { JSON.parse(body) }
            let(:data) { parsed_json['data'] }

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

              context 'when 2 organisation_types exist' do
                before do
                  create(:organisation_type, name: 'Local Authority')
                  create(:organisation_type, name: 'House Builder')
                end

                describe 'the JSON array' do
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

                context 'given a page size of 1' do
                  let(:params) { {'page[size]' => '1'} }

                  it 'has one data element' do
                    expect(data.length).to eq(1)
                  end

                  context 'and a page number of 2' do
                    before { params['page[number]'] = '2' }

                    context 'given a sort on name' do
                      before { params['sort'] = 'name' }

                      it 'contains the last element by name' do
                        expect(data[0]['attributes']['name']).to eq('Local Authority')
                      end
                    end
                    context 'given an inverse sort on name' do
                      before { params['sort'] = '-name' }

                      it 'contains the first element by name' do
                        expect(data[0]['attributes']['name']).to eq('House Builder')
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
end
