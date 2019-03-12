require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 Engagements", type: :request do
  let(:headers) { {} }
  let(:params) { {} }
  let(:stakeholder) { create(:person, name: 'Jane Doe') }
  let(:recorded_by) { create(:person, name: 'Bob Dobbs' )}

  context 'a JSON request' do
    let(:headers) {
      {
        "ACCEPT" => "application/json",     # This is what Rails 4 accepts
        "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
      }
    }

    context 'with no authentication' do
      describe 'DELETE :id' do
        let(:model_instance) { create(:engagement) }
        let(:url) { "/api/v1/engagements/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', Engagement

      end

      describe 'PATCH :id' do
        let(:model_instance) { create(:engagement) }
        let(:url) { "/api/v1/engagements/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'engagement',
              id: model_instance.id,
              attributes: {
                next_steps: "new next steps"
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'engagement',
              id: model_instance.id,
              attributes: {
                stakeholder_id: nil
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', Engagement
      end


      describe 'POST' do
        let(:url) { "/api/v1/engagements" }
        let(:valid_params) do
          {
            data: {
              type: 'engagement',
              attributes: {
                recorded_by_id: recorded_by.id,
                stakeholder_id: stakeholder.id
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'engagement',
              attributes: {
                name: ''
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', Engagement
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/engagements/#{model_instance.id}" }
        let(:model_instance) do
          create(:engagement)
        end

        it_behaves_like 'a JSON:API-compliant show method', Engagement
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/engagements' }
        let(:stakeholder) { create(:stakeholder) }
        let(:model_instance_1) { create(:engagement, stakeholder: stakeholder, contact_date: (Time.now - 1.days).to_date.to_s) }
        let(:model_instance_2) { create(:engagement, stakeholder: stakeholder, contact_date: (Time.now - 2.days).to_date.to_s) }
        let(:sort_attribute) { 'contact_date' }

        it_behaves_like 'a JSON:API-compliant index method', Engagement
      end
    end
  end
end
