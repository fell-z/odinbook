FactoryBot.define do
  factory :follow_request do
    sender factory: :user
    receiver factory: :user
  end
end
