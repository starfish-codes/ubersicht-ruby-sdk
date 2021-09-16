module Ubersicht
  module Ingestion
    module Types
      include ::Dry.Types()
    end

    class Event < ::Dry::Struct
      attribute :event_code, Types::String
      attribute :event_date, Types::String
      attribute :transaction_type, Types::String # DeviceBinding
      attribute :payload, Types::Hash.optional.default({}.freeze)
      # payload.event_date
      # payload.event_group_id
      # payload.event_id
    end
  end
end
