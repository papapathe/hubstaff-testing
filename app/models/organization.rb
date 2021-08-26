# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :projects
  has_many :tasks, through: :projects

  validates :name, presence: true
end
