require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

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
        let(:model_instance) { create(:organisation_type, name: 'existing organisation_type') }
        let(:url) { "/api/v1/organisation_types/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', OrganisationType

      end

      describe 'PATCH :id' do
        let(:model_instance) { create(:organisation_type, name: 'existing organisation_type') }
        let(:url) { "/api/v1/organisation_types/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'organisation_type',
              id: model_instance.id,
              attributes: {
                name: 'valid new organisation_type name'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'organisation_type',
              id: model_instance.id,
              attributes: {
                name: ''
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', OrganisationType
      end


      describe 'POST' do
        let(:url) { "/api/v1/organisation_types" }
        let(:valid_params) do
          {
            data: {
              type: 'organisation_type',
              attributes: {
                name: 'new organisation_type'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'organisation_type',
              attributes: {
                name: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', OrganisationType
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/organisation_types/#{model_instance.id}" }
        let(:model_instance) do
          create(:organisation_type, name: 'Local Authority')
        end

        it_behaves_like 'a JSON:API-compliant show method', OrganisationType
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/organisation_types' }
        let(:model_instance_1) { create(:organisation_type, name: 'Local Authority') }
        let(:model_instance_2) { create(:organisation_type, name: 'House Builder') }
        let(:sort_attribute) { 'name' }

        it_behaves_like 'a JSON:API-compliant index method', OrganisationType
      end
    end
  end
end
