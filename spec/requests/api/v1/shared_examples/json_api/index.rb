# Requires the following methods to be defined in the enclosing block:
# url (the URL of the method)
# model_instance_1 (a let block to create an instance of the model_class)
# model_instance_2 (a let block to create another instance of the model_class)
# sort_attribute (an attribute by which a sort will order model_instance_1 AFTER model_instance_2)
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
                  expect(element.keys).to include("attributes", "id", "links", "type")
                end
              end
              it 'has the attributes of the model_class instance' do
                data.each do |element|
                  expect(element['attributes'].keys).to match_array(model_class.new.attributes.keys)
                end
              end
              it 'has the expected type for an array of the model class' do
                data.each do |element|
                  expect(element['type']).to eq(model_class.name.underscore.pluralize)
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
