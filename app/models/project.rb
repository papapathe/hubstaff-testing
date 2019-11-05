class Project < ApplicationRecord
  validates :name, presence: true

  has_many :tasks
  belongs_to :organization
end
