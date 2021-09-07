RSpec.describe Ubersicht::Ingestion::BuildIngestionEvent do
	let(:hmac_key) { 'sample-hmac-key' }
  let(:provider) { Ubersicht::Ingestion::DAUTH_PROVIDER }

  it 'returns attributes' do
	  event = ingestion_event
    allow_any_instance_of(Ubersicht::Ingestion::HmacValidator).to receive(:calculate_notification_hmac)
      .and_return(signature = "i8+r3XFTM67R6+pNmvf8+b4fAo9xOd1x8uvUwT4UmBo=")
    expected = {
      :event_code => event.event_code,
      :event_date => event.event_date,
      :payload => {
        :hmac_signature=>signature
      },
      :provider => provider,
      :transaction_id => event.transaction_id,
      :type => event.type
    }
    expect(described_class.call(event, hmac_key, provider)).to eq(expected)
  end

  it 'validates event type' do
    event = ingestion_event(type: 'UnknownType')
    expect { described_class.call(event, hmac_key, provider) }.to raise_error(Ubersicht::Error, /#{event.type}/)
  end
end
