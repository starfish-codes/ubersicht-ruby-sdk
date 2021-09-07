module Ubersicht
  module Ingestion
    ACCEPTED_RESPONSE = '[accepted]'.freeze
    ACCEPTED_STATUS = 200
    REJECTED_RESPONSE = '[rejected]'.freeze
    REJECTED_STATUS = 400

    PROVIDERS = [
      DAUTH_PROVIDER = 'DAuth'.freeze
    ].freeze

    PROVIDER_TO_TYPES_MAP = {
      DAUTH_PROVIDER => %w[
        Authentication
        DeviceBinding
      ]
    }.freeze
  end
end
