class SerializablePolicyArea < JSONAPI::Serializable::Resource
  type :policy_areas

  attributes :id, :slug, :name, :created_at, :updated_at

  link :self do
    @url_helpers.api_v1_policy_area_path(@object.id)
  end
end
