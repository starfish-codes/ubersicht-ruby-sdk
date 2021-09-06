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

      def call(event, hmac_key)
        attrs = @event_class.new(event).to_h
        attrs[:payload][:hmac_signature] = @validate_hmac.calculate_notification_hmac(attrs, hmac_key)
        attrs
      end
    end
  end
end
