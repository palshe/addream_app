require 'rails_helper'

RSpec.describe "User::Confirmations", type: :request do
  describe "GET /user/confirmations" do
    it "works! (now write some real specs)" do
      get user_confirmations_path
      expect(response).to have_http_status(200)
    end
  end
end
