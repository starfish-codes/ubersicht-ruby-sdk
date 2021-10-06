RSpec.describe Ubersicht::Ingestion::Client do
  let(:account_id) { '100' }
  let(:hmac_key) { '44782DEF547AAA06C910C43932B1EB0C71FC68D9D0C057550C48EC2ACF6BA056' }
  let(:url) { 'http://test.de' }

  def build_client(options = {})
    described_class.new(build_options(options))
  end

  def build_options(custom = {})
    {
      account_id: account_id,
      debug: true,
      pass: 'pass',
      url: url,
      user: 'user'
    }.merge(custom)
  end

  describe '.new' do
    it { expect(build_client).to be_a(described_class) }
    it { expect { build_client(account_id: '') }.to raise_error(ArgumentError, /Account id/) }
    it { expect { build_client(account_id: nil) }.to raise_error(ArgumentError, /Account id/) }
    it { expect { build_client(pass: '') }.to raise_error(ArgumentError, /Password/) }
    it { expect { build_client(pass: nil) }.to raise_error(ArgumentError, /Password/) }
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
        transaction_type: 'DeviceBinding',
        payload: {
          event_date: Time.now.round.iso8601(3),
          event_group_id: 'some-transaction-id',
          test_field: 'test value'
        }
      }
      default_attrs.merge(attrs)
    end

    def build_url
      "#{url}/api/v1/accounts/#{account_id}/events"
    end

    it 'ingests data' do
      stub_request(:post, build_url).to_return(status: 200, body: body = 'OK')

      expect(client.ingest(event.fetch(:transaction_type), event.fetch(:event_code), event.fetch(:payload))).to eq(body)

      body = {
        event: event
      }
      headers = {
        'Authorization' => 'Basic dXNlcjpwYXNz'
      }
      expect(WebMock).to have_requested(:post, build_url).with(body: body.to_json, headers: headers)
    end

    it 'ingests with debug=false' do
      stub_request(:post, build_url).to_return(status: 200)

      client = build_client(debug: false)
      expect(client.ingest('test', 'test')).to be_nil
    end

    it 'rejects event without event_code' do
      expect { client.ingest('test', nil) }.to raise_error(ArgumentError, 'Event code cannot be blank')
    end

    it 'rejects event without transaction_type' do
      expect { client.ingest(nil, 'test') }.to raise_error(ArgumentError, 'Transaction type cannot be blank')
    end

    it 'responds with exception' do
      stub_request(:post, build_url).to_return(status: 422, body: 'rejected')

      expect { client.ingest('test', 'test') }.to raise_error(Ubersicht::Error, /rejected/)
    end
  end
end
