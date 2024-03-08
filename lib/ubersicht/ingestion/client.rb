module Ubersicht
  module Ingestion
    class Client
      def self.default(*args)
        require 'logger'

        new(*args) do |faraday|
          faraday.request :url_encoded
          # faraday.response :raise_error
          faraday.response :logger, ::Logger.new($stdout),
                           headers: { request: false, response: false },
                           bodies: { request: true, response: true }
          faraday.adapter  Faraday.default_adapter # make requests with Net::HTTP
        end
      end

      def initialize(options = {}, &block)
        raise ArgumentError, 'Token cannot be blank' if empty?(token = options[:token])
        raise ArgumentError, 'Url cannot be blank' if empty?(url = options[:url])

        @debug = options[:debug] || false
        @conn = setup_conn(url, token, &block)
      end

      def ingest(source, type, payload = {})
        raise ArgumentError, 'Source cannot be blank' if empty?(source)
        raise ArgumentError, 'Transaction type cannot be blank' if empty?(type)

        body = {
          event: {
            source: source,
            type: type,
            payload: payload
          }
        }
        process { handle_response(@conn.post('api/v1/events', body.to_json)) }
      end

      private

      attr_reader :debug

      def process(&block)
        return yield if debug

        Thread.new(&block)
        nil
      end

      def handle_response(response)
        case response.status
        when 200..299
          response.body
        when 300..599
          raise ::Ubersicht::Error, response.body
        end
      end

      def empty?(value)
        value.to_s.empty?
      end

      def setup_conn(url, token)
        headers = {
          'Content-Type' => 'application/json'
        }
        Faraday.new(url: url, headers: headers) do |conn|
          conn.request :authorization, 'Token', -> { %(token="#{token}") }

          yield(conn) if block_given?
        end
      end
    end
  end
end
