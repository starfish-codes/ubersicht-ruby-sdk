require 'dry-struct'
require 'faraday'

require 'ubersicht/version'
require 'ubersicht/ingestion'
require 'ubersicht/ingestion/build_ingestion_event'
require 'ubersicht/ingestion/client'
require 'ubersicht/ingestion/event'
require 'ubersicht/ingestion/hmac_validator'

module Ubersicht
  Error = Class.new(StandardError)
  ValidationError = Class.new(Error)
end
