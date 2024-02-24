require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "新規登録" do
    let! (:user)  { create(:user) }
    before do
      visit new_user_registration_path
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
      fill_in 'user[email]', with: 'test@test.com'
      fill_in 'user[password]', with: '111111'
      fill_in 'user[password_confirmation]', with: '111111'
    end
    it "正しく表示されているか" do
      expect(page.status_code).to eq(200)
    end
    it "name入力フォームをもっているか" do
      expect(page).to have_field 'user[name]'
    end
    it "email入力フォームをもっているか" do
      expect(page).to have_field 'user[email]'
    end
    it "password入力フォームをもっているか" do
      expect(page).to have_field 'user[password]'
    end
    it "password_confirmation入力フォームをもっているか" do
      expect(page).to have_field 'user[password_confirmation]'
    end
    it "送信ボタンがあるか" do
      expect(page).to have_button '送信'
    end
    it "ログインはこちらのリンクはあるか" do
      expect(page).to have_link 'ログインはこちら', href: "/users/sign_in"
    end
    it "正しい値を入れた場合、ホームにリダイレクトする" do
      click_button '送信'
      expect(current_path).to eq root_path
    end
    it "名前が無くてもうまくいく" do
      fill_in 'user[name]', with: ""
      click_button '送信'
      expect(current_path).to eq root_path
    end
    it "emailがないと422とエラーメッセージ" do
      fill_in 'user[email]', with: ""
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "メールアドレスを入力してください"
    end
    it "emailがすでに登録してあると422とエラーメッセージ" do
      fill_in 'user[email]', with: "example@example.com"
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "メールアドレスはすでに存在します"
    end
    it "passwordがないと422とエラーメッセージ" do
      fill_in 'user[password]', with: ""
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "パスワードを入力してください"
    end
    it "passwordが短いと422とエラーメッセージ" do
      fill_in 'user[password]', with: "aaa"
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "パスワードは6文字以上で入力してください"
    end
    it "passwordとpassword_confirmationが違うと422とエラーメッセージ" do
      fill_in 'user[password_confirmation]', with: "a"
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "確認用パスワードとパスワードの入力が一致しません"
    end
  end

  describe "ログイン" do
    before do
      visit new_user_session_path
    end
    it "正しく表示されているか" do
      expect(page.status_code).to eq(200)
    end
  end

  describe "ユーザーページ" do
  end

  describe "編集" do
  end

  describe "ログアウト" do
  end

end
