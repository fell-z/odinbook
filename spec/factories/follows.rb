FactoryBot.define do
  factory :follow do
    follower factory: :user
    followee factory: :user
    status { :accepted }
  end
end
