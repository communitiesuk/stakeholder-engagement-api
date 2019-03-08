class SerializableOrganisation < JSONAPI::Serializable::Resource
  type :organisations
  belongs_to :organisation_type
  belongs_to :region, optional: true

  attributes :id, :slug, :name, :organisation_type_id, :region_id, :created_at, :updated_at

  link :self do
    @url_helpers.api_v1_organisation_type_path(@object.id)
  end
end
