# Requires these methods to be defined in the containing scope:
# url
# valid_params    - params which will produce a valid update
# invalid_params  - params which are syntactically-correct, but will not pass
#                   model validations (e.g. a duplicate name, etc)
RSpec.shared_examples 'a JSON:API-compliant create method' do |model_class|
  let(:params) { valid_params }
  let(:perform_request) do
    post url, params: params, headers: headers
  end
  let(:policy_class) do
    Pundit::PolicyFinder.new(model_class.new).policy!
  end

  context 'when the current user is not authorized to create the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:create?).and_return(false)
    end

    it 'returns status forbidden' do
      perform_request
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when the current user is authorized to create the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:create?).and_return(true)
    end
    context 'with syntactically-correct params' do

      context 'and no validation errors' do
        let(:params) { valid_params }

        it 'creates the entity' do
          expect{ perform_request }.to change(model_class, :count).by(1)
        end

        describe 'the response' do
          let(:created_entity) { model_class.last }

          it 'has status 201 created' do
            perform_request
            expect(response).to have_http_status(:created)
          end

          # FIXME: find a better way to deduce the url_for the newly-created entity
          # (explicit :api, :v1 scope means it's only reusable within this app)
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

              it 'has the attributes of the model_class' do
                expect(data['attributes'].keys).to match_array(model_class.new.attributes.keys)
              end
              
              it 'has the expected type for an array of the model class' do
                expect(data['type']).to eq(model_class.name.underscore.pluralize)
              end
            end
          end
        end
      end

      context 'but a validation error' do
        let(:params) { invalid_params }

        it 'returns 422 unprocessable entity' do
          perform_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create the entity' do
          expect{ perform_request }.to_not change(model_class, :count)
        end
      end
    end

    context 'with syntactically-incorrect params' do
      let(:params) { {
        'name' => 'new model_instance'
      } }

      it 'returns bad_request' do
        perform_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create the entity' do
        expect{ perform_request }.to_not change(model_class, :count)
      end
    end
  end
end
