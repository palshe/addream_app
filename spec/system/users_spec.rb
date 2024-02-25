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
    let! (:user)  { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: 'example@example.com'
      fill_in 'user[password]', with: '111111'
    end
    it "正しく表示されているか" do
      expect(page.status_code).to eq(200)
    end
    it "email入力フォームをもっているか" do
      expect(page).to have_field 'user[email]'
    end
    it "password入力フォームをもっているか" do
      expect(page).to have_field 'user[password]'
    end
    it "新規登録へのリンクをもっているか" do
      expect(page).to have_link '新規登録はこちら', href: new_user_registration_path
    end
    it "パスワードを忘れた方はこちらのリンクをもっているか" do
      expect(page).to have_link 'パスワードを忘れた方はこちら', href: new_user_password_path
    end
    it "送信ボタンがあるか" do
      expect(page).to have_button '送信'
    end
    it "正しい情報を入力したらホームへリダイレクトしフラッシュメッセージが表示される" do
      click_button '送信'
      expect(current_path).to eq root_path
      expect(page).to have_content "ログインに成功しました"
    end
    it "正しい情報を入力したらログインできるか" do
      click_button '送信'
      
    end
    it "emailがないと422とエラーメッセージ" do
      fill_in 'user[email]', with: ""
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "メールアドレスまたはパスワードが正しくありません"
    end
    it "passwordがないと422とエラーメッセージ" do
      fill_in 'user[password]', with: ""
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "メールアドレスまたはパスワードが正しくありません"
    end
    it "remember_meのチェックボックスを入力したらクッキーが存在する" do
      check "rspec_check_box"
      expect(page).to have_checked_field('rspec_check_box')
      click_button '送信'
      show_me_the_cookies
      expect(get_me_the_cookie('remember_user_token')).to be_present
    end
    it "remember_meを使わないとクッキーは空" do
      click_button '送信'
      expect(get_me_the_cookie('remember_user_token')).to be_blank
    end
  end

  describe "ユーザーページ" do
  end

  describe "編集" do
  end

  describe "ログアウト" do
  end

end
