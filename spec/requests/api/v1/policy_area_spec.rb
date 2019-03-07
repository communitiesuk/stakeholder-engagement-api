require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 PolicyAreas", type: :request do
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
        let(:model_instance) { create(:policy_area, name: 'existing policy_area') }
        let(:url) { "/api/v1/policy_areas/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', PolicyArea

      end

      describe 'PATCH :id' do
        let(:model_instance) { create(:policy_area, name: 'existing policy_area') }
        let(:url) { "/api/v1/policy_areas/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'policy_area',
              id: model_instance.id,
              attributes: {
                name: 'valid new policy_area name'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'policy_area',
              id: model_instance.id,
              attributes: {
                name: ''
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', PolicyArea
      end


      describe 'POST' do
        let(:url) { "/api/v1/policy_areas" }
        let(:valid_params) do
          {
            data: {
              type: 'policy_area',
              attributes: {
                name: 'new policy_area'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'policy_area',
              attributes: {
                name: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', PolicyArea
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/policy_areas/#{model_instance.id}" }
        let(:model_instance) do
          create(:policy_area, name: 'Homelessness')
        end

        it_behaves_like 'a JSON:API-compliant show method', PolicyArea
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/policy_areas' }
        let(:model_instance_1) { create(:policy_area, name: 'Homelessness') }
        let(:model_instance_2) { create(:policy_area, name: 'Building regulations') }
        let(:sort_attribute) { 'name' }

        it_behaves_like 'a JSON:API-compliant index method', PolicyArea
      end
    end
  end
end
