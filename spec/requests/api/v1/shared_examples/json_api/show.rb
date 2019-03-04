RSpec.shared_examples 'a JSON:API-compliant show method' do |model_class|
  let(:perform_request) { get url, params: params, headers: headers }
  let(:policy_class) do
    Pundit::PolicyFinder.new(model_instance).policy!
  end

  context 'when the requested entity does not exist' do
    before do
      model_instance.id += 123
    end

    it 'returns http not found' do
      perform_request
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when the requested entity exists' do
    let(:requested_id) { model_instance.id }

    context 'when the current user is not authorized to show the entity' do
      before do
        allow_any_instance_of(policy_class).to receive(:show?).and_return(false)
      end

      it 'returns status forbidden' do
        perform_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the current user is authorized to show the entity' do
      before do
        allow_any_instance_of(policy_class).to receive(:show?).and_return(true)
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

          it 'has the attributes of the model_class' do
            expect(data['attributes'].keys).to match_array(model_class.new.attributes.keys)
          end
        end
      end
    end
  end
end
