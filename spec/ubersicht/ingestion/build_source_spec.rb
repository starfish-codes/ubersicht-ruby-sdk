RSpec.describe Ubersicht::Ingestion::BuildSource do
  it 'returns source in underscore' do
    expect(described_class.call('account_100.DAuth', 'DeviceBinding'))
      .to eq('account_100.dauth.device_binding_events')
  end

  it 'ignores events suffix' do
    expect(described_class.call('account_100.DAuth', 'DeviceBindingEvents'))
      .to eq('account_100.dauth.device_binding_events')
  end

  it 'ignores event suffix' do
    expect(described_class.call('account_100.DAuth', 'DeviceBindingEvent'))
      .to eq('account_100.dauth.device_binding_events')
  end

  it 'raises error if source type is blank' do
    expect { described_class.call('account_100.DAuth', nil) }.to raise_error(ArgumentError)
  end
end
