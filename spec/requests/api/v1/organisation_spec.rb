require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 Organisations", type: :request do
  let(:headers) { {} }
  let(:params) { {} }
  let(:organisation_type) { create(:organisation_type) }
  let(:organisation_type_2) { create(:organisation_type, name: 'House Builder')}
  let(:region) { create(:region) }

  context 'a JSON request' do
    let(:headers) {
      {
        "ACCEPT" => "application/json",     # This is what Rails 4 accepts
        "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
      }
    }

    context 'with no authentication' do
      describe 'DELETE :id' do
        let(:model_instance) { create(:organisation, name: 'existing organisation') }
        let(:url) { "/api/v1/organisations/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', Organisation

      end

      describe 'PATCH :id' do
        let(:model_instance) { create(:organisation, name: 'existing organisation') }
        let(:url) { "/api/v1/organisations/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'organisation',
              id: model_instance.id,
              attributes: {
                name: 'valid new organisation name'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'organisation',
              id: model_instance.id,
              attributes: {
                name: ''
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', Organisation
      end


      describe 'POST' do
        let(:url) { "/api/v1/organisations" }
        let(:valid_params) do
          {
            data: {
              type: 'organisation',
              attributes: {
                name: 'new organisation',
                organisation_type_id: organisation_type.id
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'organisation',
              attributes: {
                name: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', Organisation
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/organisations/#{model_instance.id}" }
        let(:model_instance) do
          create(:organisation, name: 'A Unitary Authority', organisation_type: organisation_type)
        end

        it_behaves_like 'a JSON:API-compliant show method', Organisation
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/organisations' }
        let(:model_instance_1) { create(:organisation, name: 'A Local Authority', organisation_type: organisation_type, region: region) }
        let(:model_instance_2) { create(:organisation, name: 'A Builder', organisation_type: organisation_type_2, region: region) }
        let(:sort_attribute) { 'name' }

        it_behaves_like 'a JSON:API-compliant index method', Organisation
      end
    end
  end
end
