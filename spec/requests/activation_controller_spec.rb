require 'rails_helper'

RSpec.describe "AccountActivationsController", type: :request do
  let!(:user){ create(:user) }
  before do
    user.reload
    post user_session_path, params: { user: { email: "example@example.com", password: "111111" }}
  end
  describe "new" do
    it "正しく表示されるか" do
      get new_account_activation_path
      expect(response).to have_http_status(200)
    end
  end

  describe "edit" do
    it "正しく表示されているか" do
      get edit_account_activation_path(user), params: { activation: { tel: "11111111111" } }
      expect(response).to have_http_status(200)
      expect(response.body).to include "10ケタの数字"
    end
  end

  describe "update" do
    before do
      get edit_account_activation_path(user), params: { activation: { tel: "11111111111" } }
      @random_number = controller.instance_variable_get('@random_number')
    end
    it "正しい入力とその後に戻ろうとしても戻れない" do
      patch account_activation_path(user), params: { account_activation: { activation_number: @random_number}}
      user.reload
      expect(user.activated).to be_truthy
      expect(response).to redirect_to root_path
      get edit_account_activation_path(user)
      expect(response).to redirect_to(root_path)
    end
    it "間違った入力をしたあとも同じコードで有効化できる" do
      patch account_activation_path(user), params: { account_activation: { activation_number: "1111111111"}}
      user.reload
      expect(user.activated).to be_falsey 
      patch account_activation_path(user), params: { account_activation: { activation_number: @random_number}}
      user.reload
      expect(user.activated).to be_truthy
    end
    it "時間切れ" do
      user.update(activation_sms_sent_at: 1.hours.ago)
      user.reload
      patch account_activation_path(user), params: { account_activation: { activation_number: @random_number}}
      user.reload
      expect(user.activated).to be_falsey
      expect(response).to have_http_status(422)
    end
  end
end