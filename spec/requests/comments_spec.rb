require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before do
    user = create(:user)
    sign_in user
  end

  describe "POST /posts/:post_id/comments" do
    let(:post_model) { create(:post) }
    let(:comment) { { body: comment_body } }

    context "with a valid comment" do
      let(:comment_body) { "This is a valid body." }

      it "redirects to the comment's post page with the new comment" do
        post post_comments_path(post_model), params: { comment: }

        expect(response).to redirect_to post_path(post_model)
        follow_redirect!

        expect(response.body).to include(comment_body)
      end
    end

    context "with an invalid comment" do
      let(:comment_body) { "" }

      it "renders the post page with the invalid field having a 'invalid-field' class" do
        post post_comments_path(post_model), params: { comment: }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("invalid-field")
      end
    end
  end
end
