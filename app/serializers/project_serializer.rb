class ProjectSerializer
  include JSONAPI::Serializer

  attributes :name, :organization_id, :created_at, :updated_at
end
