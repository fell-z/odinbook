require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:current_user) { create(:user) }

  before { sign_in current_user }

  describe "checking the current follow requests" do
    before { create_list(:follow, follow_request_count, followee: current_user, status: :pending) }

    context "with no follow requests" do
      let(:follow_request_count) { 0 }

      it "doesn't contain any follow request" do
        get follow_requests_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to_not include(/Accept/)
        expect(response.body).to_not include(/Refuse/)
        expect(response.body).to include("There's no pending requests.")
      end
    end

    context "with one follow request" do
      let(:follow_request_count) { 1 }

      it "contains one set of accept/refuse buttons" do
        get follow_requests_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to include(/Accept/).once
        expect(response.body).to include(/Refuse/).once
      end
    end

    context "with three follow requests" do
      let(:follow_request_count) { 3 }

      it "contains three sets of accept/refuse buttons" do
        get follow_requests_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to include(/Accept/).exactly(3).times
        expect(response.body).to include(/Refuse/).exactly(3).times
      end
    end
  end

  describe "accepting a follow request" do
    let!(:follow) { create(:follow, followee: current_user, status: :pending) }

    it "removes the follow request from the page" do
      get follow_requests_path
      expect(response).to have_http_status(:ok)

      patch follow_path(follow), as: :turbo_stream
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body)
        .to include('turbo-stream action="remove"')
        .and include("target=\"follow-user-#{follow.follower.id}\"")
    end
  end

  describe "refusing a follow request" do
    let!(:follow) { create(:follow, followee: current_user, status: :pending) }

    it "removes the follow request from the page" do
      get follow_requests_path
      expect(response).to have_http_status(:ok)

      patch follow_path(follow), as: :turbo_stream
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body)
        .to include('turbo-stream action="remove"')
        .and include("target=\"follow-user-#{follow.follower.id}\"")
    end
  end
end
