# Requires these methods to be defined in the containing scope:
# model_instance
# url
RSpec.shared_examples 'a JSON:API-compliant delete method' do |model_class|
  let(:perform_request) do
    delete url, params: params, headers: headers
  end
  let(:policy_class) do
    Pundit::PolicyFinder.new(model_instance).policy!
  end

  context 'when the current user is not authorized to delete the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:destroy?).and_return(false)
    end

    it 'returns status forbidden' do
      perform_request
      expect(response).to have_http_status(:forbidden)
    end

    it 'does not delete the entity' do
      expect{ perform_request }.to_not change(model_instance.class, :count)
    end

  end

  context 'when the current user is authorized to delete the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:destroy?).and_return(true)
    end

    it 'deletes the entity' do
      expect{ perform_request }.to change(model_instance.class, :count).by(-1)
    end

    describe 'the response' do
      it 'has status 204 No Content' do
        perform_request
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end

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

    context 'with syntactically-incorrect params' do
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

# Requires the following methods to be defined in the enclosing block:
# url (the URL of the method)
# model_instance_1 (a let block to create an instance of the model_class)
# model_instance_2 (a let block to create another instance of the model_class)
# sort_attribute (an attribute by which a sort will order model_instance_2 after model_instance_1)
RSpec.shared_examples 'a JSON:API-compliant index method' do |model_class|
  let(:perform_request) { get url, params: params, headers: headers }

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

        context 'when 2 model_class instances exist' do
          before do
            model_instance_1
            model_instance_2
          end

          describe 'the JSON array' do
            it 'has an element for each model_class instance' do
              expect(data.length).to eq(2)
            end

            describe 'each element' do
              it 'has jsonapi-compliant keys' do
                data.each do |element|
                  expect(element.keys).to match_array(["attributes", "id", "links", "type"])
                end
              end
              it 'has the attributes of the model_class instance' do
                data.each do |element|
                  expect(element['attributes'].keys).to match_array(model_class.new.attributes.keys)
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

              context 'given a sort attribute' do
                before { params['sort'] = sort_attribute }

                it 'contains the last element by sort_attribute' do
                  expect(data[0]['attributes'][sort_attribute]).to eq(model_instance_1.send(sort_attribute))
                end
              end
              context 'given an inverse sort_attribute' do
                before { params['sort'] = '-' + sort_attribute }

                it 'contains the first element by sort_attribute' do
                  expect(data[0]['attributes'][sort_attribute]).to eq(model_instance_2.send(sort_attribute))
                end
              end
            end
          end
        end
      end
    end
  end
end
