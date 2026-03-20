require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  it { should validate_presence_of(:name) }
  it { should allow_value("good@example.com").for(:email) }
  it { should_not allow_value("bad_example").for(:email) }

  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it do
    should have_many(:follow_requests_sent)
      .with_foreign_key(:sender_id)
      .class_name("FollowRequest")
      .dependent(:destroy)
  end

  it do
    should have_many(:follow_requests_received)
      .with_foreign_key(:receiver_id)
      .class_name("FollowRequest")
      .dependent(:destroy)
  end

  it do
    should have_many(:active_follows)
      .with_foreign_key(:follower_id)
      .class_name("Follow")
      .dependent(:destroy)
  end

  it do
    should have_many(:passive_follows)
      .with_foreign_key(:followee_id)
      .class_name("Follow")
      .dependent(:destroy)
  end

  it { should have_many(:followees).through(:active_follows) }
  it { should have_many(:followers).through(:passive_follows) }
end
