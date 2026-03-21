FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "foo#{n}" }
    email { "#{name.downcase}@example.com" }
    password { "test_password" }
    password_confirmation { "test_password" }
  end
end
