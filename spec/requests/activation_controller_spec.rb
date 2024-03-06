require 'rails_helper'

RSpec.describe "activation_controller", type: :request do
  let!(:user){ create(:user) }
  before do
    user.update_columns(activated: false)
      user.reload
      sign_in(user)
      get edit_account_activation_path(user)
      @random_number = controller.instance_variable_get('@random_number')
  end
  it "正しく表示されているか" do
    expect(response).to have_http_status(200)
    expect(response.body).to include "10ケタの数字"
  end
  it "正しい入力とその後に戻ろうとしても戻れない" do
    patch account_activation_path(user), params: { account_activation: { activation_number: @random_number}}
    user.reload
    expect(user.activated).to be_truthy
    expect(response).to redirect_to(users_activation_path)
    get edit_account_activation_path(user)
    expect(response).to redirect_to(users_activation_path)
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
    user.update_columns(activation_sms_sent_at: 1.hours.ago)
    user.reload
    patch account_activation_path(user), params: { account_activation: { activation_number: @random_number}}
    user.reload
    expect(user.activated).to be_falsey
    expect(response).to redirect_to(users_activation_path)
  end
end