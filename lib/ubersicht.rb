require 'dry-struct'
require 'faraday'

require 'ubersicht/helpers'
require 'ubersicht/ingestion'
require 'ubersicht/ingestion/build_event'
require 'ubersicht/ingestion/build_source'
require 'ubersicht/ingestion/client'
require 'ubersicht/ingestion/event'
require 'ubersicht/ingestion/hmac_validator'
require 'ubersicht/version'

module Ubersicht
  Error = Class.new(StandardError)
  ValidationError = Class.new(Error)
end
