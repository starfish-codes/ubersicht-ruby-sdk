module Ubersicht
  module Ingestion
    class BuildIngestionEvent
      def self.call(*args, &block)
        new.call(*args, &block)
      end

      def initialize
        @validate_hmac = ::Ubersicht::Ingestion::HmacValidator.with_ubersicht
        @event_class = ::Ubersicht::Ingestion::Event
      end

      def call(event, hmac_key, provider)
        validate_transaction_type(event[:transaction_type], provider)

        attrs = @event_class.new(event).to_h
        attrs[:payload][:hmac_signature] = @validate_hmac.calculate_notification_hmac(attrs, hmac_key)
        attrs[:provider] = provider
        attrs
      rescue ::Dry::Struct::Error => e
        raise ::Ubersicht::ValidationError, e.message
      end

      private

      def validate_transaction_type(transaction_type, provider)
        return if (types = ::Ubersicht::Ingestion::PROVIDER_TO_TYPES_MAP[provider]).include?(transaction_type)

        raise Ubersicht::Error, "Unknown type '#{transaction_type}'. #{provider} supports only #{types.join(', ')}." \
      end
    end
  end
end
