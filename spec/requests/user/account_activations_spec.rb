require 'rails_helper'

RSpec.describe "User::AccountActivations", type: :request do
  describe "GET /user/account_activations" do
    it "works! (now write some real specs)" do
      get user_account_activations_path
      expect(response).to have_http_status(200)
    end
  end
end
