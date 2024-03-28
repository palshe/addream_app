require 'rails_helper'

RSpec.describe "RegistrationController", type: :request do
  let(:user){ create(:user) }
  before do
    user.reload
  end
  describe "new" do
    it "正しく表示されるか" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe "create" do
    it "正しく入力すると人数が一人増える" do
      expect{ post user_registration_path, 
                params: { user: { name: "ishii haruki",
                                  email: "example@example2.com",
                                  password: "example",
                                  password_confirmation: "example"} }
            }.to change{ User.count }.by(1)
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include "あなたのメールアドレス宛にメッセージが送信されました。リンクに従ってメールアドレスを検証してください。"
    end
    it "メールが送信される" do
      expect{ post user_registration_path, 
                params: { user: { name: "ishii haruki",
                                  email: "example@example2.com",
                                  password: "example",
                                  password_confirmation: "example"} }
            }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
    it "emailが空欄だと人数は変わらない" do
      expect{ post user_registration_path, 
                params: { user: { name: "ishii haruki",
                                  email: "",
                                  password: "example",
                                  password_confirmation: "example"} }
            }.to change{ User.count }.by(0)
      expect(response.body).to include "メールアドレスを入力してください"
    end
    it "passwordが空欄だと人数は変わらない" do
      expect{ post user_registration_path, 
                params: { user: { name: "ishii haruki",
                                  email: "example@example2.com",
                                  password: "",
                                  password_confirmation: ""} }
            }.to change{ User.count }.by(0)
      expect(response.body).to include "パスワードを入力してください"
    end
    it "passwordとconfirmationが違うと人数は変わらない" do
      expect{ post user_registration_path, 
                params: { user: { name: "ishii haruki",
                                  email: "example@example2.com",
                                  password: "example",
                                  password_confirmation: ""} }
            }.to change{ User.count }.by(0)
      expect(response.body).to include "確認用パスワードとパスワードの入力が一致しません"
    end
    it "すでに登録されているメールアドレスだと人数は変わらない" do
      expect{ post user_registration_path, 
                params: { user: { name: "ishii haruki",
                                  email: "example@example.com",
                                  password: "example",
                                  password_confirmation: "example"} }
            }.to change{ User.count }.by(0)
      expect(response.body).to include "メールアドレスはすでに存在します"
    end
  end

  context "ログインが必要" do
    before do
      post user_session_path, params: { user: { email: "example@example.com", password: "111111" }}
    end
    describe "edit" do
      it "正しく表示されるか" do
        get edit_user_registration_path
        expect(response).to have_http_status(200)
      end
      it "ログインしていないときにはアクセスできない" do
        delete destroy_user_session_path
        get edit_user_registration_path
        expect(response).to have_http_status(302)
      end
    end
    
    describe "update" do
      it "パスワードと名前を変更" do
        patch user_registration_path, params: { user: { name: "イシイ ハルキ",
                                                        email: "example@example.com",
                                                        password: "example",
                                                        password_confirmation: "example" } }
        user.reload
        expect(response).to redirect_to users_show_path
        expect(user.name).to eq "イシイ ハルキ"
        delete destroy_user_session_path
        post user_session_path, params: { user: { email: "example@example.com", password: "example" }}
        expect(response).to redirect_to root_path
      end
      it "パスワードは入力なしでも通る" do
        patch user_registration_path, params: { user: { name: "イシイ ハルキ",
                                                        email: "example@example.com",
                                                        password: "",
                                                        password_confirmation: "" } }
        user.reload
        expect(user.name).to eq "イシイ ハルキ"
        expect(user.password).to eq "111111"
      end
      it "メールアドレスを変更" do
        expect{ patch user_registration_path,
                params: { user: { name: "石井 春輝",
                                  email: "example2@example.com",
                                  password: "",
                                  password_confirmation: "" } }
              }.to change { ActionMailer::Base.deliveries.size }.by(1)
        user.reload
        expect(user.unconfirmed_email).to eq "example2@example.com"
      end
      it "ログインしていないときにはアクセスできない" do
        delete destroy_user_session_path
        patch user_registration_path, params: { user: { name: "イシイ ハルキ",
                                                        email: "example@example.com",
                                                        password: "example",
                                                        password_confirmation: "example" } }
        expect(response).to have_http_status(302)
      end
    end
  end
end
