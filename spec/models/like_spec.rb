require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { create(:like) }

  it { should belong_to(:post) }
  it { should belong_to(:user) }
end
