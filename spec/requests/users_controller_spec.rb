require 'rails_helper'

RSpec.describe "users_controller", type: :request do
  let! (:user) { create(:user) }
  describe "#show" do
    context "ログインしていない場合に/showにアクセス" do
      it "ログイン画面にリダイレクトする" do
        get users_show_path
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "ログインしている場合に/showにアクセス" do
      it "ユーザーページに飛ぶ" do
        sign_in(user)
        get users_show_path
        expect(response).to have_http_status(200)
        expect(response.body).to include user.email
        expect(response.body).to include "ユーザー情報"
      end
    end
  end
  describe "#edit" do
    context "ログインしていない場合に/editにアクセス" do
      it "ログイン画面にリダイレクトする" do
        get edit_user_registration_path
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "ログインしている場合に/editにアクセス" do
      it "ユーザーページに飛ぶ" do
        sign_in(user)
        get edit_user_registration_path
        expect(response).to have_http_status(200)
        expect(response.body).to include "変更しない場合は空欄のまま"
        expect(response.body).to include "編集"
      end
    end
  end
end