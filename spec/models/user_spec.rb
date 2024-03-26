require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'モデルsu' do
    let(:pre_user) { create(:user, name: "イシイ ハルキ", email: "ishii@haruki.com") }
    let(:user) { build(:user) }
    it "有効なモデル" do
      expect(user).to be_valid
    end
    it "名前が空欄で有効" do
      user.name = ""
      expect(user).to be_valid
    end
    it "名前が同じでも有効" do
      user.name = pre_user.name
      expect(user).to be_valid
    end
    it "無効なpassword" do
      user.password = "11111"
      expect(user).to_not be_valid
    end
    it "passwordが空欄で無効" do
      user.password = ""
      expect(user).to_not be_valid
    end
    it "passwordがnilで無効" do
      user.password = nil
      expect(user).to_not be_valid
    end
    it "password_confirmationが一致しないと無効" do
      user.password_confirmation = ""
      expect(user).to_not be_valid
    end
    it "無効なemail" do
      user.email = "abcd"
      expect(user).to_not be_valid
    end
    it "emailが空欄で無効" do
      user.email = ""
      expect(user).to_not be_valid
    end
    it "emailがnilで無効" do
      user.email = nil
      expect(user).to_not be_valid
    end
    it "emailが同じだと無効" do
      user.email = pre_user.email
      expect(user).to_not be_valid
    end
  end
end