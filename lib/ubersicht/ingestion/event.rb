module Ubersicht
  module Ingestion
    module Types
      include ::Dry.Types()
    end

    class Event < ::Dry::Struct
      attribute :event_code, Types::String
      attribute :event_date, Types::Time || Types::DateTime
      attribute :transaction_id, Types::String.optional.default(nil)
      attribute :type, Types::String # DeviceBinding
      attribute :payload, Types::Hash.optional.default({}.freeze)
    end
  end
end
