require 'rails_helper'
require 'support/factory_bot'
require 'requests/api/v1/shared_examples/json_api'

describe "API V1 EngagementPolicyAreas", type: :request do
  let(:headers) { {} }
  let(:params) { {} }
  let(:region) { Region.last }
  let(:engagement) { create(:engagement) }
  let(:policy_area_1) { create(:policy_area, name: 'ZZZZ') }
  let(:policy_area_2) { create(:policy_area, name: 'AAAA') }

  let(:model_instance) do
    create(:engagement_policy_area, engagement: engagement,
                                    policy_area: policy_area_1)
  end

  context 'a JSON request' do
    let(:headers) {
      {
        "ACCEPT" => "application/json",     # This is what Rails 4 accepts
        "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
      }
    }

    context 'with no authentication' do
      describe 'DELETE :id' do
        let(:url) { "/api/v1/engagement_policy_areas/#{model_instance.id}" }
        it_behaves_like 'a JSON:API-compliant delete method', EngagementPolicyArea

      end

      describe 'PATCH :id' do
        let(:url) { "/api/v1/engagement_policy_areas/#{model_instance.id}" }
        let(:valid_params) do
          {
            data: {
              type: 'engagement_policy_areas',
              id: model_instance.id,
              attributes: {
                engagement_id: engagement.id,
                policy_area_id: policy_area_2.id
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'engagement_policy_areas',
              id: model_instance.id,
              attributes: {
                engagement_id: nil
              }
            }
          }
        end
        it_behaves_like 'a JSON:API-compliant update method', EngagementPolicyArea
      end


      describe 'POST' do
        let(:url) { "/api/v1/engagement_policy_areas" }
        let(:valid_params) do
          {
            data: {
              type: 'engagement_policy_areas',
              attributes: {
                engagement_id: engagement.id,
                policy_area_id: policy_area_1.id
              }
            }
          }
        end
        let(:invalid_params) do
          {
            data: {
              type: 'engagement_policy_areas',
              attributes: {
                engagement_id: nil,
                policy_area_id: policy_area_1.id
              }
            }
          }
        end

        it_behaves_like 'a JSON:API-compliant create method', EngagementPolicyArea
      end

      describe 'GET #show with ID' do
        let(:url) { "/api/v1/engagement_policy_areas/#{model_instance.id}" }

        it_behaves_like 'a JSON:API-compliant show method', EngagementPolicyArea
      end

      describe 'GET #index' do
        let(:url) { '/api/v1/engagement_policy_areas' }

        let(:model_instance_1) do
          create(:engagement_policy_area,
                  engagement: engagement,
                  policy_area: policy_area_1)
        end
        let(:model_instance_2) do
          create(:engagement_policy_area,
                  engagement: engagement,
                  policy_area: policy_area_2)
        end

        let(:sort_attribute) { 'policy_area.name' }

        it_behaves_like 'a JSON:API-compliant index method', EngagementPolicyArea
      end
    end
  end
end
