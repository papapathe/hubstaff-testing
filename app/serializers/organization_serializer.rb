class OrganizationSerializer
  include JSONAPI::Serializer

  attributes :name, :created_at
end
