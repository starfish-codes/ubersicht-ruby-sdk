module Ubersicht
  module Ingestion
    # source: https://github.com/Adyen/adyen-ruby-api-library/blob/92e3fc98de808375ad701ba459aec3425d49c43c/spec/utils/hmac_validator_spec.rb
    class HmacValidator
      DATA_SEPARATOR = ':'.freeze
      HMAC_ALGORITHM = 'sha256'.freeze

      ADYEN_HMAC_SIGNATURE_PATH = 'additionalData.hmacSignature'.freeze
      ADYEN_VALIDATION_KEYS = %w[pspReference
                                 originalReference
                                 merchantAccountCode
                                 merchantReference
                                 amount.value
                                 amount.currency
                                 eventCode
                                 success].freeze

      UBERSICHT_HMAC_SIGNATURE_PATH = 'payload.hmac_signature'.freeze
      UBERSICHT_VALIDATION_KEYS = %w[payload.event_group_id
                                     payload.event_id
                                     transaction_type
                                     event_code
                                     event_date].freeze

      def self.with_adyen
        new(ADYEN_HMAC_SIGNATURE_PATH, ADYEN_VALIDATION_KEYS)
      end

      def self.with_ubersicht
        new(UBERSICHT_HMAC_SIGNATURE_PATH, UBERSICHT_VALIDATION_KEYS)
      end

      def initialize(hmac_signature_path, validation_keys)
        @hmac_signature_path = hmac_signature_path
        @validation_keys = validation_keys
      end

      def calculate_notification_hmac(notification_request_item, hmac_key)
        data = data_to_sign(notification_request_item)

        Base64.strict_encode64(OpenSSL::HMAC.digest(HMAC_ALGORITHM, [hmac_key].pack('H*'), data))
      end

      def data_to_sign(notification_request_item)
        validation_keys
          .map { |key| fetch(notification_request_item, key).to_s }
          .map { |value| value.gsub('\\', '\\\\').gsub(':', '\\:') }
          .join(DATA_SEPARATOR)
      end

      def valid_notification_hmac?(notification_request_item, hmac_key)
        expected_sign = calculate_notification_hmac(notification_request_item, hmac_key)
        merchant_sign = fetch(notification_request_item, hmac_signature_path)

        expected_sign == merchant_sign
      end

      def valid_notifications?(notification_request_items, hmac_key)
        notification_request_items.all? do |notification_request_item|
          valid_notification_hmac?(notification_request_item, hmac_key)
        end
      end

      private

      attr_reader \
        :hmac_signature_path,
        :validation_keys

      def fetch(hash, keys)
        keys.to_s.split('.').reduce(hash) do |acc, key|
          next acc if acc.nil?

          if key.to_i.to_s == key
            acc[key.to_i]
          else
            acc[key].nil? ? acc[key.to_sym] : acc[key]
          end
        end
      end
    end
  end
end
