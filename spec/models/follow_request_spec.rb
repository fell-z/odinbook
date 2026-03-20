require 'rails_helper'

RSpec.describe FollowRequest, type: :model do
  subject(:follow_request) { create(:follow_request) }

  it { should belong_to(:sender).class_name("User") }
  it { should belong_to(:receiver).class_name("User") }

  it do
    should validate_uniqueness_of(:sender_id)
      .scoped_to(:receiver_id)
      .with_message("already sent a follow request")
  end

  context "when an user tries to send a follow request to himself" do
    let(:user) { create(:user) }
    subject(:invalid_follow_request) { build(:follow_request, sender: user, receiver: user) }

    it "shouldn't be valid" do
      expect(invalid_follow_request).to be_invalid
    end
  end
end
