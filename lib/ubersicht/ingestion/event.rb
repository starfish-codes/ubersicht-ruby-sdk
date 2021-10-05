module Ubersicht
  module Ingestion
    module Types
      include ::Dry.Types()
    end

    class Event < ::Dry::Struct
      attribute :id, Types::String
      attribute :type, Types::String
      attribute :source, Types::String
      attribute :time, Types::String
      attribute :data, Types::Hash
      # data.event_group_id
    end
  end
end
