class SerializableRoleType < JSONAPI::Serializable::Resource
  type :role_types

  attributes :id, :slug, :name, :created_at, :updated_at

  link :self do
    @url_helpers.api_v1_role_type_path(@object.id)
  end
end
