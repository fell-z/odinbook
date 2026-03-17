require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { create(:post) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(500) }
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
end
