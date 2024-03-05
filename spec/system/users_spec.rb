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
      expect(page).to have_content "ログインしました"
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
    let! (:user) { create(:user) }
    before do
      sign_in(user)
      visit users_show_path
    end
    it "正しく表示されているか" do
      expect(page.status_code).to eq(200)
    end
    it "編集ページへのリンクをもっているか" do
      expect(page).to have_link '変更する', href: edit_user_registration_path
    end
    it "ホームへのリンクをもっているか" do
      expect(page).to have_link 'ホームに戻る', href: root_path
    end
    it "名前が表示されているか" do
      expect(page).to have_content user.name
    end
    it "idが表示されているか" do
      expect(page).to have_content user.id
    end
    it "名前が表示されているか" do
      expect(page).to have_content user.email
    end
  end

  describe "編集" do
    let! (:user)  { create(:user) }
    before do
      sign_in(user)
      visit edit_user_registration_path
      fill_in 'user[name]', with: 'test_user'
      fill_in 'user[email]', with: 'update-example@example.com'
      fill_in 'user[password]', with: '222222'
      fill_in 'user[password_confirmation]', with: '222222'
    end
    it "正しく表示されているか" do
      expect(page.status_code).to eq(200)
      expect(page).to have_content "編集"
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
    it "ユーザーページへのリンクをもっているか" do
      expect(page).to have_link 'ユーザーページへ戻る', href: users_show_path
    end
    it "送信ボタンがあるか" do
      expect(page).to have_button '送信'
    end
    it "正しい情報を入力したらユーザーページへリダイレクトしフラッシュメッセージが表示される" do
      click_button '送信'
      expect(current_path).to eq users_show_path
      expect(page).to have_content "アカウント情報が更新されました。"
      user.reload
      expect(user.name).to eq "test_user"
      expect(user.email).to eq "update-example@example.com"
    end
    it "passwordがなくても通る" do
      fill_in 'user[password]', with: ""
      fill_in 'user[password_confirmation]', with: ""
      click_button '送信'
      expect(current_path).to eq users_show_path
      expect(page).to have_content "アカウント情報が更新されました"
    end
    it "emailがないと422とエラーメッセージ" do
      fill_in 'user[email]', with: ""
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "メールアドレスを入力してください"
    end
    it "emailが大文字でも小文字に変換される" do
      fill_in 'user[email]', with: "TEST@TEST.COM"
      click_button '送信'
      user.reload
      expect(user.email).to eq 'test@test.com'
    end
    it "passwordはなしでpassword_confirmationはあり" do
      fill_in 'user[password_confirmation]', with: ""
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "確認用パスワードとパスワードの入力が一致しません"
    end
    it "passwordはなしでpassword_confirmationはあり" do
      fill_in 'user[password]', with: ""
      click_button '送信'
      expect(page).to have_http_status(422)
      expect(page).to have_content "確認用パスワードとパスワードの入力が一致しません"
    end
    it "passwordを変更したら変更後のパスワードでログインできる" do
      click_button '送信'
      user.reload
      click_link 'ログアウト'
      visit new_user_session_path
      fill_in 'user[email]', with: "update-example@example.com"
      fill_in 'user[password]', with: "222222"
      click_button '送信'
      expect(page).to have_content "ログインしました"
      expect(current_path).to eq root_path
    end
    it "nameを未入力だと表示されなくなる" do
      fill_in 'user[name]', with: ""
      click_button '送信'
      expect(current_path).to eq users_show_path
      expect(page).to_not have_content "#{user.name}さん"
    end
  end

  describe "ログアウト" do
    let! (:user) { create(:user) }
    it "ホームに戻ってフラッシュメーセージが表示される" do
      sign_in(user)
      visit users_show_path
      click_link "ログアウト"
      expect(current_path).to eq root_path
      expect(page).to have_content "ログアウトしました"
      expect(page).to have_link "ログイン", href: new_user_session_path
      expect(page).to have_link "新規登録", href: new_user_registration_path
    end
    it "cookieが消える" do
      visit new_user_session_path
      fill_in 'user[email]', with: 'example@example.com'
      fill_in 'user[password]', with: '111111'
      check "rspec_check_box"
      click_button "送信"
      expect(get_me_the_cookie('remember_user_token')).to be_present
      visit users_show_path
      click_link "ログアウト"
      expect(get_me_the_cookie('remember_user_token')[:value]).to be_blank
    end
  end

  describe "パスワードリセット" do
    #include EmailSpec::Helpers
    #include EmailSpec::Matchers
    let! (:user) { create(:user) }
    before do
      visit new_user_password_path
      fill_in 'user[email]', with: user.email
    end
    it "正しく表示されているか" do
      expect(page.status_code).to eq(200)
    end
    it "email入力フォームをもっているか" do
      expect(page).to have_field 'user[email]'
    end
    it "本人確認メールを送信するボタンを持っているか" do
      expect(page).to have_button "本人確認メールを送信する"
    end
    it "メールアドレスが有効ではない場合エラーメッセージを出力するか" do
      fill_in 'user[email]', with: ""
      click_button "本人確認メールを送信する"
      expect(page).to have_http_status(422)
      #expect(page).to have_content ""
    end
    it "本人確認メールを送信するを押すと送信完了画面に移動する" do
      click_button "本人確認メールを送信する"
      expect(current_path).to eq users_passwordreset_path
      expect(page).to have_content "パスワードリセット用のメールを送信しました。"
    end
    describe "メール送信" do
      before do
        clear_emails
        click_button '本人確認メールを送信する'
        open_email(user.email)
      end
      it "パスワード編集ページに飛び、ページの中身はただしいか" do
        current_email.click_link 'change my password!'
        expect(current_path).to eq "/users/password/edit.#{user.id}"
        expect(page).to have_field 'user[password]'
        expect(page).to have_field 'user[password_confirmation]'
      end
      it "無効なパスワード" do
        current_email.click_link 'change my password!'
        fill_in 'user[password]', with: "222"
        fill_in 'user[password_confirmation]', with: ""
        click_button '送信'
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
      end
      it "emailの内容は正しいか" do
        expect(current_email).to have_content "Hi! #{user.email}"
        expect(current_email).to have_link "change my password!"
      end
      it "パスワード変更後にトークンの有効期限は切れているか" do
        current_email.click_link 'change my password!'
        path = current_url
        fill_in 'user[password]', with: "111111"
        fill_in 'user[password_confirmation]', with: "111111"
        click_button '送信'
        expect(current_path).to eq root_path
        click_link 'ログアウト'
        visit path
        fill_in 'user[password]', with: "111111"
        fill_in 'user[password_confirmation]', with: "111111"
        click_button '送信'
        expect(page).to have_http_status(422)
      end
    end
  end
end
