class AccountActivationsController < ApplicationController
  before_action :authenticate_user!
  include SmsSend

  def edit
    if @user = User.find(:id)
      random_number = Twilio.random_number_generator(10)
      digest = User.digest(ramdom_number)
      @user.update_columns(activation_digest: digest, activation_sms_sent_at: Time.now)
      Twilio.send_sms(user.phone, random_number)
    else
      flash[:danger] = "ログインしてください。"
      redirect_to new_user_registration_path
  end

  def update
    if @user.activation_digest_expired?
      if @user.activation_authenticate(params[:account_activation][:activation_number])
        @user.activate
        flash[:success] = "携帯番号の検証が完了しました。"
        redirect_to users_activation_path
      else
        flash.now[:danger] = "コードが間違っています。送信されたSMSを確認してください。"
        render 'edit', status: :unprocessable_entity
      end
    else
      flash[:danger] = "コードの期限が切れています。もう一度お試しください。"
      redirect_to users_activation_path ,status: :see_other
    end
  end
end
#Twilio.send_sms(resource.phone, edit_account_activation_url(resource.activation_token, email: resource.email))