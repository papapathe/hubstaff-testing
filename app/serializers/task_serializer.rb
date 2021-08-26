# frozen_string_literal: true

class TaskSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :project_id, :created_at, :updated_at
end
