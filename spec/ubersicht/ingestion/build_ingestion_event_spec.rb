RSpec.describe Ubersicht::Ingestion::BuildIngestionEvent do
  let(:hmac_key) { 'sample-hmac-key' }
  let(:provider) { Ubersicht::Ingestion::DAUTH_PROVIDER }

  it 'returns attributes' do
    payload = {
      event_group_id: event_group_id = 'some-transaction-id'
    }
    event = ingestion_event.new(payload: payload)
    allow_any_instance_of(Ubersicht::Ingestion::HmacValidator).to receive(:calculate_notification_hmac)
      .and_return(signature = 'i8+r3XFTM67R6+pNmvf8+b4fAo9xOd1x8uvUwT4UmBo=')
    expected = {
      event_code: event.event_code,
      event_date: event.event_date,
      payload: {
        hmac_signature: signature,
        event_group_id: event_group_id
      },
      provider: provider,
      transaction_type: event.transaction_type
    }
    expect(described_class.call(event, hmac_key, provider)).to eq(expected)
  end

  it 'validates event transaction_type' do
    event = ingestion_event(transaction_type: 'UnknownType')
    expect do
      described_class.call(event, hmac_key, provider)
    end.to raise_error(Ubersicht::Error, /#{event.transaction_type}/)
  end
end
