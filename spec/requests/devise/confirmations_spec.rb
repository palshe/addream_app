require 'rails_helper'

RSpec.describe "ConfirmationsController", type: :request do
  let(:user){ create(:user) }
  let(:unconfirmed_user){ create(:user, email: "xample@example.com", confirmation_sent_at: nil, confirmed_at: nil) }
  before do
    user.reload
    unconfirmed_user.reload
  end
  describe "new" do
    it "正しく表示されるか" do
      get new_user_confirmation_path
      expect(response).to have_http_status(200)
    end
  end

  describe "create" do
    it "正しく入力するとメールが送られる" do
      expect{ post user_confirmation_path, params: { user: { email: "xample@example.com" } }
            }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
    it "存在しないメールアドレスでエラー" do
      expect{ post user_confirmation_path, params: { user: { email: "example@example.om" } }
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end
    it "すでに有効化済みでエラー" do
      expect{ post user_confirmation_path, params: { user: { email: "example@example.com" } }
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end
  end

  describe "show" do
    before do
      unconfirmed_user.update(confirmation_sent_at: Time.zone.now, confirmation_token: "token")
      unconfirmed_user.reload
    end
    it "リンクをクリックしたらconfirmed" do
      get '/users/confirmation?confirmation_token=token'
      expect(response).to redirect_to new_user_session_path
      unconfirmed_user.reload
      expect(unconfirmed_user.confirmed_at).to_not eq nil
    end
  end
end
