require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 Regions", type: :request do
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
        let(:model_instance) { create(:region, name: 'existing region', nuts_code: 'ABC') }
        let(:url) { "/api/v1/regions/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', Region

      end

      describe 'PATCH :id' do
        let(:model_instance) { create(:region, name: 'existing region', nuts_code: 'ABC') }
        let(:url) { "/api/v1/regions/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'region',
              id: model_instance.id,
              attributes: {
                name: 'valid new region name',
                nuts_code: 'GHI'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'region',
              id: model_instance.id,
              attributes: {
                name: ''
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', Region
      end


      describe 'POST' do
        let(:url) { "/api/v1/regions" }
        let(:valid_params) do
          {
            data: {
              type: 'region',
              attributes: {
                name: 'new region',
                nuts_code: 'LMN'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'region',
              attributes: {
                name: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', Region
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/regions/#{model_instance.id}" }
        let(:model_instance) do
          create(:region, name: 'The North', nuts_code: 'ABC')
        end

        it_behaves_like 'a JSON:API-compliant show method', Region
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/regions' }
        let(:model_instance_1) { create(:region, name: 'The North', nuts_code: 'DEF') }
        let(:model_instance_2) { create(:region, name: 'The South', nuts_code: 'ABC') }
        let(:sort_attribute) { 'nuts_code' }

        it_behaves_like 'a JSON:API-compliant index method', Region
      end
    end
  end
end
