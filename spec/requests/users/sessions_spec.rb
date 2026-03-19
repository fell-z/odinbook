require 'rails_helper'

RSpec.describe "User Sessions", type: :request do
  describe "GET /login" do
    it "renders the 'new' page" do
      get login_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Log in")
    end
  end

  describe "POST /users/sign_in" do
    context "when the user credentials are valid" do
      it "redirects to the root" do
        pending("root path to defined")

        post user_session_path, params: { user: attributes_for(:user) }

        expect(response).to redirect_to(root_path)
      end
    end

    context "when the user credentials are invalid" do
      it "renders the 'new' form again" do
        post user_session_path, params: { user: attributes_for(:user, password: "wrong_password") }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Log in")
      end
    end
  end
end
