require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe 'Home' do
    before do
      visit root_path
    end
   it "ホームページのアクセス" do
    expect(page.status_code).to eq(200)
   end
   it "helpへのリンクがあるか" do
    expect(page).to have_link 'Help', href: "/help"
   end
   it "aboutへのリンクがあるか" do
    expect(page).to have_link 'Admineとは？', href: "/about"
   end
   it "ログインボタンがあるか" do
    expect(page).to have_link 'ログイン', href: "/users/sign_in"
   end
   it "新規登録ボタンがあるか" do
    expect(page).to have_link '新規登録', href: "/users/sign_up"
   end
  end
end
