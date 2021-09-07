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

      def initialize(options = {}, &block) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        raise ArgumentError, 'Account id cannot be blank' if empty?(account_id = options[:account_id])
        raise ArgumentError, 'Hmac key cannot be blank' if empty?(hmac_key = options[:hmac_key])
        raise ArgumentError, 'Password cannot be blank' if empty?(pass = options[:pass])
        raise ArgumentError, 'Url cannot be blank' if empty?(url = options[:url])
        raise ArgumentError, 'Username cannot be blank' if empty?(user = options[:user])
        unless ::Ubersicht::Ingestion::PROVIDERS.include?(provider = options[:provider])
          raise ArgumentError, "Not supported provider '#{provider}'"
        end

        @account_id = account_id
        @hmac_key = hmac_key
        @provider = provider
        @conn = setup_conn(url, user, pass, &block)
      end

      def ingest_events(events)
        body = {
          events: events.map { |event| ::Ubersicht::Ingestion::BuildIngestionEvent.call(event, hmac_key, provider) }
        }
        url = "accounts/#{account_id}/plugins/#{provider.downcase}/notification_webhooks"
        handle_response(@conn.post(url, body.to_json))
      end

      private

      attr_reader :account_id, :hmac_key, :provider

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
