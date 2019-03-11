class SerializableRole < JSONAPI::Serializable::Resource
  type :roles
  belongs_to :organisation
  belongs_to :person
  belongs_to :region, optional: true
  belongs_to :role_type

  attributes  :id, :slug, :title, :organisation_id, :person_id, :role_type_id,
              :region_id, :created_at, :updated_at

  link :self do
    @url_helpers.api_v1_role_path(@object.id)
  end
end
