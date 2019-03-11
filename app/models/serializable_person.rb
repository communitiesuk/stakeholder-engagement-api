class SerializablePerson < JSONAPI::Serializable::Resource
  type :people

  attributes :id, :slug, :name, :title, :created_at, :updated_at

  has_many :roles 

  link :self do
    @url_helpers.api_v1_people_path(@object.id)
  end
end
