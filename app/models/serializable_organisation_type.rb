class SerializableOrganisationType < JSONAPI::Serializable::Resource
  type :organisation_types

  attributes :id, :slug, :name, :created_at, :updated_at

  link :self do
    @url_helpers.api_v1_organisation_type_path(@object.id)
  end
end
