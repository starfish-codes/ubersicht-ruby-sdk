module Ubersicht
  module Ingestion
    class BuildEvent
      def self.call(*args, &block)
        new.call(*args, &block)
      end

      def initialize
        @build_source = ::Ubersicht::Ingestion::BuildSource
        @event_class = ::Ubersicht::Ingestion::Event
      end

      def call(id, source_prefix, source_type, type, data) # rubocop:disable Metrics/MethodLength
        attrs = {
          id: id,
          source: @build_source.call(source_prefix, source_type),
          type: type,
          time: build_time,
          data: data
        }
        validate(attrs)
        attrs
      rescue ::Dry::Struct::Error => e
        raise ::Ubersicht::ValidationError, e.message
      end

      private

      def build_time
        Time.now.iso8601(3)
      end

      def validate(attrs)
        @event_class.new(attrs)
      end
    end
  end
end
