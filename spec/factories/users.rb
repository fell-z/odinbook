FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "foo#{n}" }
    email { Faker::Internet.email }
    password { "test_password" }
    password_confirmation { "test_password" }
  end
end
