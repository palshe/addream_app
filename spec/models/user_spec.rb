require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザーモデルのバリデーション' do
    let(:user) { build(:user) }
    it "有効なモデル" do
      expect(user).to be_valid
    end
    it "名前が空欄" do
      user.name = ""
      expect(user).to be_valid
    end
    it "無効なpassword" do
      user.password = "11111"
      expect(user).to_not be_valid
    end
    it "passwordが空欄" do
      user.password = ""
      expect(user).to_not be_valid
    end
    it "passwordがnil" do
      user.password = nil
      expect(user).to_not be_valid
    end
    it "password_confirmationが一致しない" do
      user.password_confirmation = ""
      expect(user).to_not be_valid
    end
    it "無効なemail" do
      user.email = "abcd"
      expect(user).to_not be_valid
    end
    it "emailが空欄" do
      user.email = ""
      expect(user).to_not be_valid
    end
    it "emailがnil" do
      user.email = nil
      expect(user).to_not be_valid
    end
  end
end

#presenceはemailとpasswordにしかかかってない