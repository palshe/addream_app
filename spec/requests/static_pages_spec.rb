require 'rails_helper'

RSpec.describe "StaticPagesControllerとView", type: :request do
  describe "home" do
    let(:user){ create(:user, confirmation_sent_at: Time.zone.now, confirmed_at: Time.zone.now) }
    it "ログインしていない状態で正しく表示されるか" do
      get root_path
      expect(response).to have_http_status(200)
      expect(response.body).to include "ログイン"
    end
    it "ログインしている状態で正しく表示されるか" do
      user.reload
      post user_session_path, params: { user: { email: "example@example.com", password: "111111" }}
      get root_path
      expect(response.body).to include "ログアウト"
    end
  end

  it "about" do
    get about_path
    expect(response).to have_http_status(200)
  end
  it "help" do
    get help_path
    expect(response).to have_http_status(200)
  end
  it "rules" do
    get rules_path
    expect(response).to have_http_status(200)
  end
  it "privacypolicy" do
    get privacypolicy_path
    expect(response).to have_http_status(200)
  end
end
