# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'Password123' }
    password_confirmation { 'Password123' }
    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :with_invalid_password do
      password { 'password123' }
      password_confirmation { 'password123' }
    end
  end
end
