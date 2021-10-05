module TestHelpers
  module Factories
    def attributes_for(factory_name, attrs = {}) # rubocop:disable Metrics/MethodLength
      case factory_name
      when :ingestion_event
        defaults = {
          id: 'some-id',
          type: 'some-code',
          time: Time.now.round.iso8601(3),
          source: 'account_1.dauth.device_binding_events',
          data: {
            #   event_group_id: 'some-transaction-id',
            #   test_field: 'test value'
          }
        }
        defaults.merge(attrs)
      end
    end

    def build(factory_name, attrs = {})
      case factory_name
      when :ingestion_event
        ::Ubersicht::Ingestion::Event.new(attributes_for(factory_name, attrs))
      end
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::Factories
end
