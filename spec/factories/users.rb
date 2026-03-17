FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "test_password" }
    password_confirmation { "test_password" }
  end
end
