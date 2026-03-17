FactoryBot.define do
  factory :post do
    body { Faker::Lorem.paragraph }
    user
  end
end
