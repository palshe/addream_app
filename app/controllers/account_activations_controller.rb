class AccountActivationsController < ApplicationController
  before_action :authenticate_user!
  before_action :activated_user
  before_action :check_expiration, only: [:update]
  include SmsSend

  def edit
    if @user = User.find(params[:id])
      @random_number = Twilio.random_number_generator(10)
      digest = User.digest(@random_number)
      @message = Twilio.send_sms(@user.phone, @random_number)
      if Rails.env.production? #本番環境用
        if !@message.nil?
          flash.now[:danger] = @message
          redirect_to users_activation_path
        else
        @user.update_columns(activation_digest: digest, activation_sms_sent_at: Time.now)
        render 'edit'
        end
      else #開発環境、テスト環境用
        if !@message.nil?
          flash.now[:danger] = @message
          #redirect_to users_activation_path
        end
        @user.update_columns(activation_digest: digest, activation_sms_sent_at: Time.now)
        render 'edit'
      end
    else
      flash[:danger] = "ログインしてください。"
      redirect_to new_user_registration_path
    end
  end

  def update
    if @user = User.find(params[:id])
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
    if current_user.activation_digest_expired?
      flash[:danger] = "コードの期限が切れています。もう一度お試しください。"
      redirect_to users_activation_path
    end
  end

  def activated_user
    if current_user.activated
      flash[:success] = "すでに有効化されています。"
      redirect_to users_activation_path
    end
  end
end