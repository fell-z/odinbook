require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:current_user) { create(:user) }
  before { sign_in current_user }

  describe "GET /users" do
    let(:user_count) { 5 }
    let!(:users) { create_list(:user, user_count) }

    it "should not include the current user" do
      get users_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to_not include(current_user.name)
    end

    context "when the current user doesn't follow/requested any of the users" do
      it "shows buttons to follow for all of them" do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(/<button.+?>Follow<\/button>/).exactly(5).times
      end
    end

    context "when the current user requested a follow to two of the users" do
      before do
        2.times do |i|
          create(:follow, follower: current_user, followee: users[i], status: :pending)
        end
      end

      it "shows buttons to cancel the follow request for two of the users" do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(/<button.+?>Cancel request<\/button>/).exactly(2).times
      end

      it "shows buttons to follow for three of the users" do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(/<button.+?>Follow<\/button>/).exactly(3).times
      end
    end

    context "when the current user follows three users and requested a follow to one of the users" do
      before do
        3.times do |i|
          create(:follow, follower: current_user, followee: users[i])
        end
        create(:follow, follower: current_user, followee: users[3], status: :pending)
      end

      it "shows buttons to unfollow for three of the users" do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(/<button.+?>Unfollow<\/button>/).exactly(3).times
      end

      it "shows buttons to cancel the follow request for one of the users" do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(/<button.+?>Cancel request<\/button>/).exactly(1).times
      end

      it "shows buttons to follow for one of the users" do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(/<button.+?>Follow<\/button>/).exactly(1).times
      end
    end
  end
end
