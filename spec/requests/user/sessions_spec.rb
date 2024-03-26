require 'rails_helper'

RSpec.describe "SessionsController", type: :request do
  let(:user){ create(:user, confirmation_sent_at: Time.zone.now, confirmed_at: Time.zone.now) }
  describe "new" do
    it "正しく表示されるか" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "create" do
    it "正しいログイン" do
      user.reload
      post user_session_path, params: { user: { email: "example@example.com", password: "111111" }}
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include "ログインしました。"
    end
    it "存在しないemailでログイン" do
      user.reload
      post user_session_path, params: { user: { email: "example@example.co", password: "111111" }}
      expect(response.body).to include "メールアドレスまたはパスワードが正しくありません"
    end
    it "間違ったパスワードでログイン" do
      user.reload
      post user_session_path, params: { user: { email: "example@example.com", password: "11111" }}
      expect(response.body).to include "メールアドレスまたはパスワードが正しくありません"
    end
  end

  describe "delete" do
    it "ログアウト" do
      user.reload
      post user_session_path, params: { user: { email: "example@example.com", password: "111111" }}
      delete destroy_user_session_path
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include "ログアウトしました"
    end
  end

end
