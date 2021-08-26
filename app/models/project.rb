# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :tasks
  belongs_to :organization

  validates :name, presence: true
end
