# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Internet.email }
    last_login_secret { SecureRandom.hex(8) }
    password { 'MyPassword' }
  end
end
