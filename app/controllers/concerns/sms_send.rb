module SmsSend
  extend ActiveSupport::Concern
  class Twilio
    class TwilioServerError < StandardError; end
    class TwilioClientError < StandardError; end
    require 'twilio-ruby'
    class << self
      def client
        @client ||= ::Twilio::REST::Client.new('', '')
        #ホントはENV['ACCOUNT_SID'], ENV['AUTH_TOKEN']
      end
      def send_sms(to, code)
        formatted_number = PhonyRails.normalize_number( to , country_code: 'JP') 
        begin
          client.api.account.messages.create(
            from: '', #ホントはENV['PHONE_NUMBER']
            to: formatted_number,
            body: "認証URL: #{code}"
          )
        rescue ::Twilio::REST::RestError => e
          @message = "#{e.message}, アカウントを有効化できませんでした。電話番号をご確認の上、ヘッダーのリンクからアカウント有効化を行ってください。"

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