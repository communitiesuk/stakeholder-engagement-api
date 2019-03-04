require 'rails_helper'
require 'support/factory_bot'

describe "API V1 OrganisationTypes", type: :request do
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

      describe 'DELETE :id' do
        let!(:organisation_type) { create(:organisation_type, name: 'existing organisation_type') }
        let(:perform_request) do
          delete "/api/v1/organisation_types/#{organisation_type.id}", params: params, headers: headers
        end

        context 'when the current user is not authorized to delete the entity' do
          before do
            allow_any_instance_of(OrganisationTypePolicy).to receive(:destroy?).and_return(false)
          end

          it 'returns status forbidden' do
            perform_request
            expect(response).to have_http_status(:forbidden)
          end

          it 'does not delete the entity' do
            expect{ perform_request }.to_not change(OrganisationType, :count)
          end

        end

        context 'when the current user is authorized to delete the entity' do
          it 'deletes the entity' do
            expect{ perform_request }.to change(OrganisationType, :count).by(-1)
          end

          describe 'the response' do
            it 'has status 204 No Content' do
              perform_request
              expect(response).to have_http_status(:no_content)
            end
          end
        end
      end

      describe 'PATCH :id' do
        let(:organisation_type) { create(:organisation_type, name: 'existing organisation_type') }
        let(:new_name) { 'new organisation_type name' }
        let(:valid_params) do
          {
            data: {
              type: 'organisation_type',
              id: organisation_type.id,
              attributes: {
                name: new_name
              }
            }
          }
        end
        let(:params) { valid_params }
        let(:perform_request) do
          patch "/api/v1/organisation_types/#{organisation_type.id}", params: params, headers: headers
        end

        context 'when the current user is not authorized to update the entity' do
          before do
            allow_any_instance_of(OrganisationTypePolicy).to receive(:update?).and_return(false)
          end

          it 'returns status forbidden' do
            perform_request
            expect(response).to have_http_status(:forbidden)
          end
        end

        context 'when the current user is authorized to update the entity' do

          context 'with valid params' do
            let(:params) { valid_params }

            context 'and a unique name' do
              let(:name) { 'unique name' }

              it 'creates the entity' do
                expect{ perform_request }.to change(OrganisationType, :count).by(1)
              end

              describe 'the response' do
                it 'has status 200 OK' do
                  perform_request
                  expect(response).to have_http_status(:ok)
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

            context 'but a name that is already present' do
              let(:name) { 'duplicate name' }
              before do
                create(:organisation_type, name: 'new organisation_type name')
              end

              it 'returns 422 unprocessable entity' do
                perform_request
                expect(response).to have_http_status(:unprocessable_entity)
              end

              it 'does not update the entity' do
                expect{ perform_request }.to_not change(organisation_type, :updated_at)
              end
            end
          end

          context 'with invalid params' do
            let(:params) { {
              'name' => 'new organisation_type'
            } }

            it 'returns bad_request' do
              perform_request
              expect(response).to have_http_status(:bad_request)
            end

            it 'does not update the entity' do
              expect{ perform_request }.to_not change(organisation_type, :updated_at)
            end
          end
        end
      end


      describe 'POST' do
        let(:name) { 'new organisation_type' }
        let(:valid_params) do
          {
            data: {
              type: 'organisation_type',
              attributes: {
                name: name
              }
            }
          }
        end
        let(:params) { valid_params }
        let(:perform_request) do
          post "/api/v1/organisation_types/", params: params, headers: headers
        end

        context 'when the current user is not authorized to create the entity' do
          before do
            allow_any_instance_of(OrganisationTypePolicy).to receive(:create?).and_return(false)
          end

          it 'returns status forbidden' do
            perform_request
            expect(response).to have_http_status(:forbidden)
          end
        end

        context 'when the current user is authorized to create the entity' do

          context 'with valid params' do
            let(:params) { valid_params }

            context 'and a unique name' do
              let(:name) { 'unique name' }

              it 'creates the entity' do
                expect{ perform_request }.to change(OrganisationType, :count).by(1)
              end

              describe 'the response' do
                let(:created_entity) { OrganisationType.where(name: name).last }

                it 'has status 201 created' do
                  perform_request
                  expect(response).to have_http_status(:created)
                end

                it 'has a Location header with the URL of the entity' do
                  perform_request
                  expect(response.headers['Location']).to eq(url_for([:api, :v1, created_entity]))
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

            context 'but a name that is already present' do
              let(:name) { 'duplicate name' }
              before do
                create(:organisation_type, name: 'duplicate name')
              end

              it 'returns 422 unprocessable entity' do
                perform_request
                expect(response).to have_http_status(:unprocessable_entity)
              end

              it 'does not creates the entity' do
                expect{ perform_request }.to_not change(OrganisationType, :count)
              end
            end
          end

          context 'with invalid params' do
            let(:params) { {
              'name' => 'new organisation_type'
            } }

            it 'returns bad_request' do
              perform_request
              expect(response).to have_http_status(:bad_request)
            end

            it 'does not create the entity' do
              expect{ perform_request }.to_not change(OrganisationType, :count)
            end
          end
        end
      end

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

          context 'when the current user is not authorized to show the entity' do
            before do
              allow_any_instance_of(OrganisationTypePolicy).to receive(:show?).and_return(false)
            end

            it 'returns status forbidden' do
              perform_request
              expect(response).to have_http_status(:forbidden)
            end
          end

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
