class Organization < ApplicationRecord
  validates :name, presence: true

  has_many :projects
  has_many :tasks, through: :projects
end
