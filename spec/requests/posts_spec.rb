require 'rails_helper'

RSpec.describe "Posts", type: :request do
  before do
    user = create(:user)
    sign_in user
  end

  describe "GET /posts" do
    context "with one post created" do
      let!(:post) { create(:post) }

      it "contains a post" do
        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(post.body)
      end
    end

    context "with two posts created" do
      let!(:first_post) { create(:post) }
      let!(:second_post) { create(:post) }

      it "contains two posts" do
        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(first_post.body)
        expect(response.body).to include(second_post.body)
      end

      it "shows the posts ordered by most recent" do
        get posts_path

        expect(response).to have_http_status(:ok)

        first_post_position = response.body.index(first_post.body)
        second_post_position = response.body.index(second_post.body)

        expect(first_post_position).to_not be_nil, "expected to find first post body in response but found none"
        expect(second_post_position).to_not be_nil, "expected to find second post body in response but found none"
        expect(second_post_position).to be < first_post_position, "expected to find the second created post first"
      end
    end
  end
end
