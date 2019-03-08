class SerializableRegion < JSONAPI::Serializable::Resource
  type :regions

  attributes :id, :slug, :name, :nuts_code, :created_at, :updated_at

  link :self do
    @url_helpers.api_v1_region_path(@object.id)
  end
end
