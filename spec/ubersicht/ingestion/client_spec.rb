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
    it { expect { build_client(pass: '') }.to raise_error(ArgumentError, /Password/) }
    it { expect { build_client(pass: nil) }.to raise_error(ArgumentError, /Password/) }
    it { expect { build_client(provider: nil) }.to raise_error(ArgumentError, /Provider/) }
    it { expect { build_client(url: '') }.to raise_error(ArgumentError, /Url/) }
    it { expect { build_client(url: nil) }.to raise_error(ArgumentError, /Url/) }
    it { expect { build_client(user: '') }.to raise_error(ArgumentError, /Username/) }
    it { expect { build_client(user: nil) }.to raise_error(ArgumentError, /Username/) }
  end

  describe '.default' do
    it { expect(described_class.default(build_options)).to be_a(described_class) }
  end

  describe '.ingest' do
    let(:event) { build(:ingestion_event) }
    let(:client) { build_client }

    def build_url
      "#{url}/api/v1/events"
    end

    it 'ingests data' do
      stub_request(:post, build_url).to_return(status: 200)

      time = Time.now
      allow(Time).to receive(:now).and_return(time)

      client.ingest(event.id, 'DeviceBinding', type = 'confirm', data: event.data)

      body = {
        event: {
          id: event.id,
          source: "account_#{account_id}.dauth.device_binding_events",
          type: type,
          time: time.iso8601(3),
          data: event.data
        }
      }
      headers = {
        'Authorization' => 'Basic dXNlcjpwYXNz'
      }
      expect(WebMock).to have_requested(:post, build_url).with(body: body, headers: headers)
    end

    it 'ingests with debug=false' do
      stub_request(:post, build_url).to_return(status: 200)

      client = build_client(debug: false)
      expect(client.ingest(event.id, 'DeviceBinding', event.type)).to be_nil
    end

    it 'responds with exception' do
      stub_request(:post, build_url).to_return(status: 500, body: 'rejected')

      expect { client.ingest(event.id, 'Authentication', event.type) }.to raise_error(Ubersicht::Error, /rejected/)
    end
  end
end
