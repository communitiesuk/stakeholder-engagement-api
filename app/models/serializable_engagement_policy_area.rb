class SerializableEngagementPolicyArea < JSONAPI::Serializable::Resource
  type :engagement_policy_areas
  belongs_to :engagement
  belongs_to :policy_area

  attributes  :id, :engagement_id, :policy_area_id, :created_at, :updated_at

  link :self do
    @url_helpers.api_v1_engagement_policy_area_path(@object.id)
  end
end
