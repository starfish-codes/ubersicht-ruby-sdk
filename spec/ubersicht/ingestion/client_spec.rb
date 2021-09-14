RSpec.describe Ubersicht::Ingestion::Client do
  let(:account_id) { '100' }
  let(:hmac_key) { '44782DEF547AAA06C910C43932B1EB0C71FC68D9D0C057550C48EC2ACF6BA056' }
  let(:url) { 'http://test.de' }

  def build_client(options = {})
    described_class.new(build_options(options))
  end

  def build_options(custom = {})
    {
      debug: true,
      hmac_key: hmac_key,
      account_id: account_id,
      pass: 'pass',
      provider: ::Ubersicht::Ingestion::DAUTH_PROVIDER,
      url: url,
      user: 'user'
    }.merge(custom)
  end

  describe '.new' do
    it { expect(build_client).to be_a(described_class) }
    it { expect { build_client(account_id: '') }.to raise_error(ArgumentError, /Account id/) }
    it { expect { build_client(account_id: nil) }.to raise_error(ArgumentError, /Account id/) }
    it { expect { build_client(hmac_key: '') }.to raise_error(ArgumentError, /Hmac/) }
    it { expect { build_client(hmac_key: nil) }.to raise_error(ArgumentError, /Hmac/) }
    it { expect { build_client(pass: '') }.to raise_error(ArgumentError, /Password/) }
    it { expect { build_client(pass: nil) }.to raise_error(ArgumentError, /Password/) }
    it { expect { build_client(provider: 'unknown') }.to raise_error(ArgumentError, /provider/) }
    it { expect { build_client(url: '') }.to raise_error(ArgumentError, /Url/) }
    it { expect { build_client(url: nil) }.to raise_error(ArgumentError, /Url/) }
    it { expect { build_client(user: '') }.to raise_error(ArgumentError, /Username/) }
    it { expect { build_client(user: nil) }.to raise_error(ArgumentError, /Username/) }
  end

  describe '.default' do
    it { expect(described_class.default(build_options)).to be_a(described_class) }
  end

  describe '.ingest' do
    let(:event) { build_event }
    let(:client) { build_client }

    def build_event(attrs = {})
      default_attrs = {
        event_code: 'some-code',
        event_date: Time.now.round,
        transaction_type: 'DeviceBinding',
        payload: {
          event_group_id: 'some-transaction-id',
          test_field: 'test value'
        }
      }
      ::Ubersicht::Ingestion::Event.new(default_attrs.merge(attrs))
    end

    def build_url
      "#{url}/accounts/#{account_id}/plugins/dauth/notification_webhooks"
    end

    it 'ingests data' do
      allow_any_instance_of(Ubersicht::Ingestion::HmacValidator).to receive(:calculate_notification_hmac)
        .with(any_args, hmac_key).and_return(hmac_signature = 'some-hmac-signature')
      stub_request(:post, build_url)
        .to_return(status: Ubersicht::Ingestion::ACCEPTED_STATUS, body: Ubersicht::Ingestion::ACCEPTED_RESPONSE)

      event_attrs = event.attributes.except(:payload).merge(event.payload)
      expect(client.ingest(**event_attrs)).to eq(Ubersicht::Ingestion::ACCEPTED_RESPONSE)

      body = {
        events: [
          {
            event_code: event.event_code,
            event_date: event.event_date,
            transaction_type: event.transaction_type,
            payload: event.payload.to_h.merge(
              hmac_signature: hmac_signature,
              event_group_id: event.payload[:event_group_id]
            ),
            provider: Ubersicht::Ingestion::DAUTH_PROVIDER
          }
        ]
      }
      headers = {
        'Authorization' => 'Basic dXNlcjpwYXNz'
      }
      expect(WebMock).to have_requested(:post, build_url).with(body: body.to_json, headers: headers)
    end

    it 'ingests with debug=false' do
      allow_any_instance_of(Ubersicht::Ingestion::HmacValidator).to receive(:calculate_notification_hmac)
        .with(any_args, hmac_key)
      stub_request(:post, build_url)
        .to_return(status: Ubersicht::Ingestion::ACCEPTED_STATUS, body: Ubersicht::Ingestion::ACCEPTED_RESPONSE)

      client = build_client(debug: false)
      expect(client.ingest(**event.attributes)).to be_nil
    end

    it 'rejects event without event_code' do
      event_attrs = build_event.attributes.except(:event_code)
      expect { client.ingest(**event_attrs) }.to raise_error(ArgumentError, 'missing keyword: :event_code')
    end

    it 'rejects event without transaction_type' do
      event_attrs = build_event.attributes.except(:transaction_type)
      expect { client.ingest(**event_attrs) }.to raise_error(ArgumentError, 'missing keyword: :transaction_type')
    end

    it 'responds with exception' do
      stub_request(:post, build_url)
        .to_return(status: Ubersicht::Ingestion::REJECTED_STATUS, body: Ubersicht::Ingestion::REJECTED_RESPONSE)

      expect { client.ingest(**event.attributes) }.to raise_error(Ubersicht::Error, /rejected/)
    end
  end
end
