require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:current_user) { create(:user) }
  before { sign_in current_user }

  describe "GET /posts" do
    context "with one post created" do
      let!(:post) { create(:post, user: current_user) }

      it "contains a post" do
        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(post.body)
      end
    end

    context "with two posts created" do
      let!(:first_post) { create(:post, user: current_user) }
      let!(:second_post) { create(:post, user: current_user) }

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

  describe "POST /posts" do
    context "with a valid post" do
      let(:post_attrs) { attributes_for(:post) }

      it "redirects to the posts page with the new post" do
        post posts_path, params: { post: post_attrs }

        expect(response).to redirect_to posts_path
        follow_redirect!

        expect(response.body).to include(post_attrs[:body])
      end
    end

    context "with an invalid post" do
      let(:post_attrs) { attributes_for(:post, body: "") }

      it "renders the new post form with the invalid field having a 'invalid-field' class" do
        post posts_path, params: { post: post_attrs }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("invalid-field")
      end
    end
  end

  describe "DELETE /posts/:id" do
    let(:post_model) { create(:post) }

    it "redirects to the posts page without the deleted post" do
      get post_path(post_model)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post_model.body)

      delete post_path(post_model)
      expect(response).to redirect_to posts_path
      follow_redirect!

      expect(response.body).to_not include(post_model.body)
    end
  end
end
