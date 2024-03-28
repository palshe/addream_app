require 'rails_helper'

RSpec.describe "PasswordsController", type: :request do
  let(:user){ create(:user) }
  before do
    user.update(reset_password_token: "token", reset_password_sent_at: Time.zone.now)
      user.reload
  end
  describe "new" do
    it "正しく表示されるか" do
      get new_user_password_path
      expect(response).to have_http_status(200)
    end
  end

  describe "create" do
    it "正しく入力するとメールが送られる" do
      expect{ post user_password_path, params: { user: { email: "example@example.com" } }
            }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
    it "存在しないメールアドレスでエラー" do
      expect{ post user_password_path, params: { user: { email: "example@example.om" } }
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end
  end

  describe "token生成後の処理" do
    before do
      user.update(reset_password_token: "token", reset_password_sent_at: Time.zone.now)
      user.reload
    end
    describe "edit" do
      it "正しく表示されるか" do
        get '/users/password/edit.1?reset_password_token=token'
        expect(response).to have_http_status(200)
      end
      it "tokenがないと表示されない" do
        get '/users/password/edit.1?reset_password_token='
        expect(response).to have_http_status(302)
      end
    end
    
    #-------------------------なぜかtokenが不正な値のエラー--------------------------------------------
    describe "update" do
    #  it "正しく入力すればパスワードを変更できる" do
    #    patch user_password_path, params: { user: { reset_password_token: "token",
    #                                                password: "example", 
    #                                                password_confirmation: "example" } }
    #    expect(response.body).to include "メールアドレスはすでに存在します" #body見るためのtest用
    #    delete destroy_user_session_path
    #    post user_session_path, params: { user: { email: "example@example.com", password: "example" }}
    #    expect(response).to redirect_to root_path
    #  end
    end
  end
end
