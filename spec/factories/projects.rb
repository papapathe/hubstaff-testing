# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    organization
    name { Faker::Company.buzzword }
  end
end
