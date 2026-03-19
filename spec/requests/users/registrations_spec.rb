require 'rails_helper'

RSpec.describe "User Registrations", type: :request do
  describe "GET /sign_up" do
    it "renders the 'new' page" do
      get sign_up_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign up")
    end
  end

  describe "POST /users" do
    context "when the new user is valid" do
      it "redirects to the root" do
        pending("root path to defined")

        post user_registration_path, params: { user: attributes_for(:user) }

        expect(response).to redirect_to(root_path)
      end
    end

    context "when the new user is invalid" do
      it "renders the 'new' form again" do
        post user_registration_path, params: { user: attributes_for(:user, name: "") }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Sign up")
      end
    end
  end
end
