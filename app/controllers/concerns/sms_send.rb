module SmsSend
  extend ActiveSupport::Concern
  class Twilio
    class TwilioServerError < StandardError; end
    class TwilioClientError < StandardError; end
    require 'twilio-ruby'
    class << self
      def client
        if Rails.env.production?
          @client ||= ::Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN']) #本番環境用
        else
          @client ||= ::Twilio::REST::Client.new('', '') #開発環境、テスト環境用
        end
      end
      
      def send_sms(to, code)
        formatted_number = PhonyRails.normalize_number( to , country_code: 'JP') 
        begin
          if Rails.env.production?
            client.api.account.messages.create(
            from: ENV['PHONE_NUMBER'],
            to: formatted_number,
            body: "認証コード: #{code}"
            ) #本番環境用
          else
            client.api.account.messages.create(
            from: '',
            to: formatted_number,
            body: "認証コード: #{code}"
            ) #開発環境、テスト環境用
          end
          @true
        rescue ::Twilio::REST::RestError => e
          @message = "#{e.message}, SMSが正しく送信されませんでした。電話番号をご確認の上、ヘッダーのリンクから再度アカウント有効化を行ってください。"

        end
      end
      require "securerandom"
      def random_number_generator(n)
        ''.tap { |s| n.times { s << rand(0..9).to_s } }
      end
    end
  end
end
#Twilio.send_sms(resource.phone, edit_account_activation_url(resource.activation_token, email: resource.email))