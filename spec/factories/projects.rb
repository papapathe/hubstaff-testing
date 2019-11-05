FactoryBot.define do
  factory :project do
    organization
    name { Faker::Company.buzzword }
  end
end
