class OrganizationSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :created_at
end
