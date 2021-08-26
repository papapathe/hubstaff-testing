# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project

  validates :name, :description, presence: true
end
