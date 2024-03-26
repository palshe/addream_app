class User < ApplicationRecord
  require 'bcrypt'
  validates :phone, uniqueness: true, allow_nil: true
  encrypts :phone, deterministic: true
  encrypts :email, deterministic: true, downcase: true
  encrypts :unconfirmed_email, deterministic: true, downcase: true
  #attr_accessor :activation_token
  #before_create :create_activation_digest
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable


#---------クラスメソッド--------------------------------------------------------

  class << self

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

#-------インスタンスメソッド---------------------------------------

  #deviseの機能追加
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  #SMS認証
  def activation_authenticate(token)
    return false if activation_digest.nil?
    BCrypt::Password.new(activation_digest).is_password?(token)
  end

  def activate
    update_columns(activation_digest: nil, activated: true, activated_at: Time.zone.now)
  end

  def activation_digest_expired?
    if activation_sms_sent_at
      activation_sms_sent_at < 30.minutes.ago
    else
      true
    end
  end

  private

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end