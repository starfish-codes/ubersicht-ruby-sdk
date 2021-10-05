module Ubersicht
  module Ingestion
    class BuildSource
      def self.call(*args, &block)
        new.call(*args, &block)
      end

      def initialize
        @helpers = ::Ubersicht::Helpers
      end

      def call(source_prefix, source_type)
        source_type = source_type.to_s
        raise ArgumentError, 'Source type cannot be blank' if source_type.empty?

        source_type = @helpers.underscore(source_type)
        source_type = "#{source_type}s" if /_event\Z/.match?(source_type)
        source_type = "#{source_type}_events" unless /_events\Z/.match?(source_type)

        "#{source_prefix.downcase}.#{source_type}"
      end
    end
  end
end
