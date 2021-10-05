RSpec.describe Ubersicht::Ingestion::BuildEvent do
  let(:provider) { Ubersicht::Ingestion::DAUTH_PROVIDER }

  it 'returns attributes' do
    time = Time.now
    allow(Time).to receive(:now).and_return(time)

    expected = {
      id: id = "event-id-#{rand(1000)}",
      type: type = 'some-event-type',
      data: data = {
        event_group_id: 'some-transaction-id'
      },
      source: 'account_100.dauth.device_binding_events',
      time: time.iso8601(3)
    }
    expect(described_class.call(id, 'account_100.DAuth', 'DeviceBinding', type, data)).to eq(expected)
  end
end
