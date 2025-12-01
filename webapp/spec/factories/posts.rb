# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :user
    content { 'This is a test post content' }

    trait :with_image do
      after(:build) do |post|
        post.image.attach(
          io: Rails.root.join('spec', 'fixtures', 'files', 'test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/png'
        )
      end
    end

    trait :without_content do
      content { '' }
    end

    trait :long_content do
      content { 'a' * 200 }
    end
  end
end
