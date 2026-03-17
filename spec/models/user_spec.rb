require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  it { should validate_presence_of(:name) }
  it { should allow_value("good@example.com").for(:email) }
  it { should_not allow_value("bad_example").for(:email) }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:follows).dependent(:destroy) }
  it { should have_many(:followees).through(:follows) }
end
