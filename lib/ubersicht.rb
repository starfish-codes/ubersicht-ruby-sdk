require 'base64'
require 'faraday'

require 'ubersicht/version'
require 'ubersicht/ingestion/client'
require 'ubersicht/ingestion/hmac_validator'

module Ubersicht
  Error = Class.new(StandardError)
  ValidationError = Class.new(Error)
end
