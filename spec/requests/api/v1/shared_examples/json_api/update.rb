# Requires these methods to be defined in the containing scope:
# model_instance
# url
# valid_params    - params which will produce a valid update
# invalid_params  - params which are syntactically-correct, but will not pass
#                   model validations (e.g. a duplicate name, etc)
RSpec.shared_examples 'a JSON:API-compliant update method' do |model_class|
  let(:perform_request) do
    patch url, params: params, headers: headers
  end
  let(:policy_class) do
    Pundit::PolicyFinder.new(model_instance).policy!
  end

  context 'when the current user is not authorized to update the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:update?).and_return(false)
    end

    it 'returns status forbidden' do
      perform_request
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when the current user is authorized to update the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:update?).and_return(true)
    end

    context 'with syntactically-correct params' do
      context 'and no validation errors' do
        let(:params) { valid_params }

        it 'updates the entity' do
          expect{ perform_request }.to change{ model_instance.reload.attributes }
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

              it "has the right attributes for #{model_class}" do
                expect(data['attributes'].keys).to match_array(model_class.new.attributes.keys)
              end

              it 'has the expected type for an array of the model class' do
                expect(data['type']).to eq(model_class.name.underscore.pluralize)
              end
            end
          end
        end
      end

      context 'but a validation failure' do
        let(:params) { invalid_params }

        it 'returns 422 unprocessable entity' do
          perform_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not update the entity' do
          expect{ perform_request }.to_not change(model_instance, :updated_at)
        end
      end
    end

    context 'with syntactically-incorrect params' do
      let(:params) { {
        'name' => 'something'
      } }

      it 'returns bad_request' do
        perform_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not update the entity' do
        expect{ perform_request }.to_not change(model_instance, :updated_at)
      end
    end
  end
end
