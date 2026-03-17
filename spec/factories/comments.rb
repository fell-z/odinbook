FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence(word_count: 20) }
    post
    user
  end
end
