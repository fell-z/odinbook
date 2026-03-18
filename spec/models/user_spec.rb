require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  it { should validate_presence_of(:name) }
  it { should allow_value("good@example.com").for(:email) }
  it { should_not allow_value("bad_example").for(:email) }

  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  let(:statuses) { Follow.statuses }

  context "when an user follows another user" do
    it do
      should have_many(:follow_requests_sent)
        .conditions(status: statuses[:pending])
        .with_foreign_key(:follower_id)
        .inverse_of(:follower)
        .class_name("Follow")
        .dependent(:destroy)
    end

    it do
      should have_many(:accepted_follows_sent)
        .conditions(status: statuses[:accepted])
        .with_foreign_key(:follower_id)
        .inverse_of(:follower)
        .class_name("Follow")
        .dependent(:destroy)
    end

    it { should have_many(:followees).through(:accepted_follows_sent) }
  end

  context "when an user is followed by another user" do
    it do
      should have_many(:follow_requests_received)
        .conditions(status: statuses[:pending])
        .with_foreign_key(:followee_id)
        .inverse_of(:followee)
        .class_name("Follow")
        .dependent(:destroy)
    end

    it do
      should have_many(:accepted_follows_received)
        .conditions(status: statuses[:accepted])
        .with_foreign_key(:followee_id)
        .inverse_of(:followee)
        .class_name("Follow")
        .dependent(:destroy)
    end

    it { should have_many(:followers).through(:accepted_follows_received) }
  end
end
