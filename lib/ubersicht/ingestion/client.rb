module Ubersicht
  module Ingestion
    class Client
      def self.default(*args)
        new(*args) do |faraday|
          faraday.request :url_encoded
          # faraday.response :raise_error
          faraday.response :logger, Logger.new($stdout),
                           headers: { request: false, response: false },
                           bodies: { request: true, response: true }
          faraday.adapter  Faraday.default_adapter # make requests with Net::HTTP
        end
      end

      def initialize(options = {}, &block) # rubocop:disable Metrics/AbcSize
        raise ArgumentError, 'Account id cannot be blank' if empty?(account_id = options[:account_id])
        raise ArgumentError, 'Password cannot be blank' if empty?(pass = options[:pass])
        raise ArgumentError, 'Url cannot be blank' if empty?(url = options[:url])
        raise ArgumentError, 'Username cannot be blank' if empty?(user = options[:user])
        raise ArgumentError, 'Provider cannot be blank' if empty?(provider = options[:provider])

        @debug = options[:debug] || false
        @source_prefix = "account_#{account_id}.#{provider}"
        @conn = setup_conn(url, user, pass, &block)
      end

      def ingest(id, source_type, type, data: {})
        body = {
          event: Ubersicht::Ingestion::BuildEvent.call(id, source_prefix, source_type, type, data)
        }
        process { handle_response(@conn.post('api/v1/events', body.to_json)) }
      end

      private

      attr_reader :debug, :source_prefix

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
