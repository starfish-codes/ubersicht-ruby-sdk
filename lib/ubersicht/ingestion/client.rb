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
        raise ArgumentError, 'Account id cannot be blank' if empty?(account_id = options[:account_id])
        raise ArgumentError, 'Password cannot be blank' if empty?(pass = options[:pass])
        raise ArgumentError, 'Url cannot be blank' if empty?(url = options[:url])
        raise ArgumentError, 'Username cannot be blank' if empty?(user = options[:user])

        @account_id = account_id
        @debug = options[:debug] || false
        @conn = setup_conn(url, user, pass, &block)
      end

      def ingest(transaction_type, event_code, payload = {}) # rubocop:disable Metrics/MethodLength
        raise ArgumentError, 'Transaction type cannot be blank' if empty?(transaction_type)
        raise ArgumentError, 'Event code cannot be blank' if empty?(event_code)

        body = {
          event: {
            event_code: event_code,
            transaction_type: transaction_type,
            payload: payload
          }
        }
        url = "api/v1/accounts/#{account_id}/events"
        process { handle_response(@conn.post(url, body.to_json)) }
      end

      private

      attr_reader :account_id, :debug

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

      def setup_conn(url, user, pass)
        headers = {
          'Content-Type' => 'application/json'
        }
        Faraday.new(url: url, headers: headers) do |faraday|
          faraday.request(:basic_auth, user, pass)

          yield(faraday) if block_given?
        end
      end
    end
  end
end
