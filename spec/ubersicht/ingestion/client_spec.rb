RSpec.describe Ubersicht::Ingestion::Client do
  let(:token) { 'some-api-token' }
  let(:url) { 'http://test.de' }

  def build_client(options = {})
    described_class.new(build_options(options))
  end

  def build_options(custom = {})
    {
      debug: true,
      token: token,
      url: url
    }.merge(custom)
  end

  describe '.new' do
    it { expect(build_client).to be_a(described_class) }
    it { expect { build_client(token: '') }.to raise_error(ArgumentError, /Token/) }
    it { expect { build_client(token: nil) }.to raise_error(ArgumentError, /Token/) }
    it { expect { build_client(url: '') }.to raise_error(ArgumentError, /Url/) }
    it { expect { build_client(url: nil) }.to raise_error(ArgumentError, /Url/) }
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
      "#{url}/api/v1/events"
    end

    it 'ingests data' do
      stub_request(:post, build_url).to_return(status: 200, body: body = 'OK')

      expect(client.ingest(event.fetch(:transaction_type), event.fetch(:event_code), event.fetch(:payload))).to eq(body)

      body = {
        event: event
      }
      headers = {
        'Authorization' => %(Token token="#{token}")
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
