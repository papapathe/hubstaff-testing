# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Pathe' }
    last_login_secret { SecureRandom.hex(8) }
    password { 'MyPassword' }
  end
end
