require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 Persons", type: :request do
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
        let(:model_instance) { create(:person, name: 'existing person', title: 'Ms.') }
        let(:url) { "/api/v1/people/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', Person

      end

      describe 'PATCH :id' do
        let(:model_instance) { create(:person, name: 'existing person', title: 'Ms.') }
        let(:url) { "/api/v1/people/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'person',
              id: model_instance.id,
              attributes: {
                name: 'valid new person name',
                title: 'Ms.'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'person',
              id: model_instance.id,
              attributes: {
                name: ''
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', Person
      end


      describe 'POST' do
        let(:url) { "/api/v1/people" }
        let(:valid_params) do
          {
            data: {
              type: 'person',
              attributes: {
                name: 'new person',
                title: 'Ms.'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'person',
              attributes: {
                name: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', Person
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/people/#{model_instance.id}" }
        let(:model_instance) do
          create(:person, name: 'Jane Doe', title: 'Ms.')
        end

        it_behaves_like 'a JSON:API-compliant show method', Person
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/people' }
        let(:model_instance_1) { create(:person, name: 'Jane Doe', title: 'Ms.') }
        let(:model_instance_2) { create(:person, name: 'Abby Gail', title: 'Ms.') }
        let(:sort_attribute) { 'name' }

        it_behaves_like 'a JSON:API-compliant index method', Person
      end
    end
  end
end
