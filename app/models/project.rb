# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :organization

  validates :name, presence: true
end
