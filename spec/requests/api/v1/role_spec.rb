require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 Roles", type: :request do
  let(:headers) { {} }
  let(:params) { {} }
  let(:region) { Region.last }

  let(:model_instance) do
    create(:role, title: 'Chief Digital Officer',
                  organisation: organisation,
                  person: person,
                  region: nil,
                  role_type: role_type)
  end


  let(:organisation){ create(:organisation, name: 'An organisation') }
  let(:person) { create(:person) }
  let(:role_type) { create(:role_type, name: 'Executive') }
  let(:role_type_2) { create(:role_type, name: 'HR')}
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
        let(:url) { "/api/v1/roles/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', Role

      end

      describe 'PATCH :id' do
        let(:url) { "/api/v1/roles/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'roles',
              id: model_instance.id,
              attributes: {
                title: 'valid new role title'
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'roles',
              id: model_instance.id,
              attributes: {
                title: ''
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', Role
      end


      describe 'POST' do
        let(:url) { "/api/v1/roles" }
        let(:valid_params) do
          {
            data: {
              type: 'roles',
              attributes: {
                title: 'new role',
                organisation_id: organisation.id,
                person_id: person.id,
                role_type_id: role_type.id
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'roles',
              attributes: {
                title: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', Role
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/roles/#{model_instance.id}" }

        it_behaves_like 'a JSON:API-compliant show method', Role
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/roles' }
        let(:model_instance_1) { create(:role, title: 'CFO', organisation: organisation, role_type: role_type, person: person, region: nil) }
        let(:model_instance_2) { create(:role, title: 'CDO', organisation: organisation, role_type: role_type, person: person, region: nil) }
        let(:sort_attribute) { 'title' }

        it_behaves_like 'a JSON:API-compliant index method', Role
      end
    end
  end
end
