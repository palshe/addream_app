class AccountActivationsController < ApplicationController
  before_action :authenticate_user!
  include SmsSend

  def edit
    if @user = User.find(params[:id])
      @random_number = Twilio.random_number_generator(10)
      digest = User.digest(@random_number)
      @user.update_columns(activation_digest: digest, activation_sms_sent_at: Time.now)
      #Twilio.send_sms(@user.phone, random_number)
      render 'edit'
    else
      flash[:danger] = "ログインしてください。"
      redirect_to new_user_registration_path
    end
  end

  def update
    if @user = User.find(params[:id])
      check_expiration
      if @user.activation_authenticate(params[:account_activation][:activation_number])
        @user.activate
        flash[:success] = "携帯番号の検証が完了しました。"
        redirect_to users_activation_path
      else
        flash.now[:danger] = "コードが間違っています。送信されたSMSを確認してください。"
        render 'edit', status: :unprocessable_entity
      end
    else
      flash[:danger] = "ログインしてください。"
      redirect_to new_user_registration_path
    end
  end

  def check_expiration
    if @user.activation_digest_expired?
      flash[:danger] = "コードの期限が切れています。もう一度お試しください。"
      redirect_to users_activation_path
    end
  end
end