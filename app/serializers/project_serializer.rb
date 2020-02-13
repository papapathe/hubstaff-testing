class ProjectSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :organization_id, :created_at, :updated_at
end
