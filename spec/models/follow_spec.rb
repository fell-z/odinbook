require 'rails_helper'

RSpec.describe Follow, type: :model do
  subject(:follow) { create(:follow) }

  it { should define_enum_for(:status).with_values(%i[ pending accepted ]).with_default(:pending) }

  it { should belong_to(:follower).class_name("User") }
  it { should belong_to(:followee).class_name("User") }

  it do
    should validate_uniqueness_of(:follower_id)
      .scoped_to(:followee_id)
      .with_message("already followed")
  end

  context "when an user tries to follow himself" do
    let(:user) { create(:user) }
    subject(:invalid_follow) { build(:follow, follower: user, followee: user) }

    it "shouldn't be valid" do
      expect(invalid_follow).to be_invalid
    end
  end
end
