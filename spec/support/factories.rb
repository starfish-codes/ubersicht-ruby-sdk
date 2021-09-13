module TestHelpers
  module Factories
    def ingestion_event(attrs = {})
      defaults = {
        event_code: 'some-code',
        event_date: Time.now.round,
        transaction_type: 'DeviceBinding'
        # payload: {
        #   event_group_id: 'some-transaction-id',
        #   test_field: 'test value'
        # }
      }
      ::Ubersicht::Ingestion::Event.new(defaults.merge(attrs))
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::Factories
end
