require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { create(:like) }

  it do
    should validate_uniqueness_of(:user_id).scoped_to(:post_id).with_message("already liked")
  end

  it { should belong_to(:post) }
  it { should belong_to(:user) }
end
