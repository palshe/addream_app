require 'rails_helper'

RSpec.describe "User::Passwords", type: :request do
  describe "GET /user/passwords" do
    it "works! (now write some real specs)" do
      get user_passwords_path
      expect(response).to have_http_status(200)
    end
  end
end
