class Project < ApplicationRecord
  validates :name, presence: true
  belongs_to :organization
end
