require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 RoleTypes", type: :request do
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
        let(:model_instance) { create(:role_type, name: 'existing role_type') }
        let(:url) { "/api/v1/role_types/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', RoleType

      end

      describe 'PATCH :id' do
        let(:model_instance) { create(:role_type, name: 'existing role_type') }
        let(:url) { "/api/v1/role_types/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'role_type',
              id: model_instance.id,
              attributes: {
                name: 'valid new role_type name'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'role_type',
              id: model_instance.id,
              attributes: {
                name: ''
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', RoleType
      end


      describe 'POST' do
        let(:url) { "/api/v1/role_types" }
        let(:valid_params) do
          {
            data: {
              type: 'role_type',
              attributes: {
                name: 'new role_type'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'role_type',
              attributes: {
                name: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', RoleType
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/role_types/#{model_instance.id}" }
        let(:model_instance) do
          create(:role_type, name: 'Local Authority')
        end

        it_behaves_like 'a JSON:API-compliant show method', RoleType
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/role_types' }
        let(:model_instance_1) { create(:role_type, name: 'Senior Leadership') }
        let(:model_instance_2) { create(:role_type, name: 'Personnel / HR Mgr') }
        let(:sort_attribute) { 'name' }

        it_behaves_like 'a JSON:API-compliant index method', RoleType
      end
    end
  end
end
