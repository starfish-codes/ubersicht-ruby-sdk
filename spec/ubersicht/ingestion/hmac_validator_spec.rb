RSpec.describe Ubersicht::Ingestion::HmacValidator do
  context 'with adyen' do
    subject(:validator) { described_class.with_adyen }

    let(:key) { '44782DEF547AAA06C910C43932B1EB0C71FC68D9D0C057550C48EC2ACF6BA056' }
    let(:expected_sign) { 'coqCmt/IZ4E3CzPvMY8zTjQVL5hYJUiBRg8UU+iCWo0=' }
    let(:notification_request_item) do
      {
        additionalData: {
          hmacSignature: expected_sign
        },
        amount: {
          value: 1130,
          currency: 'EUR'
        },
        pspReference: '7914073381342284',
        eventCode: 'AUTHORISATION',
        merchantAccountCode: 'TestMerchant',
        merchantReference: 'TestPayment-1407325143704',
        paymentMethod: 'visa',
        success: 'true'
      }
    end

    it 'gets correct data' do
      data_to_sign = validator.data_to_sign(notification_request_item)
      expect(data_to_sign).to eq '7914073381342284::TestMerchant:TestPayment-1407325143704:1130:EUR:AUTHORISATION:true'
    end

    it 'gets correct data without some fields' do
      data_to_sign = validator.data_to_sign(notification_request_item.merge(amount: nil))
      expect(data_to_sign).to eq '7914073381342284::TestMerchant:TestPayment-1407325143704:::AUTHORISATION:true'
    end

    it 'gets correct data with escaped characters' do
      notification_request_item['merchantAccountCode'] = 'Test:\\Merchant'
      data_to_sign = validator.data_to_sign(notification_request_item)
      expected = '7914073381342284::Test\\:\\Merchant:TestPayment-1407325143704:1130:EUR:AUTHORISATION:true'
      expect(data_to_sign).to eq(expected)
    end

    it 'encrypts properly' do
      encrypted = validator.calculate_notification_hmac(notification_request_item, key)
      expect(encrypted).to eq expected_sign
    end

    it 'has a valid hmac' do
      expect(validator).to be_valid_notification_hmac(notification_request_item, key)
    end

    it 'has an invalid hmac' do
      notification_request_item['additionalData'] = { 'hmacSignature' => 'invalidHMACsign' }

      expect(validator).not_to be_valid_notification_hmac(notification_request_item, key)
    end
  end

  context 'with ubersicht' do
    subject(:validator) { described_class.with_ubersicht }

    let(:key) { '44782DEF547AAA06C910C43932B1EB0C71FC68D9D0C057550C48EC2ACF6BA056' }
    let(:expected_sign) { 'X4jyYrXqIf1EDDpyHVXoPrzME2WWRfRgjgwOKtHe6JM=' }
    let(:notification_request_item) do
      {
        payload: {
          hmac_signature: expected_sign
        },
        event_code: 'requested',
        event_date: Time.parse('2021-05-05 10:00:55'),
        transaction_id: 'f9b07c9e',
        type: 'Authentication'
      }
    end

    it 'gets correct data' do
      data_to_sign = validator.data_to_sign(notification_request_item)
      expect(data_to_sign).to eq 'f9b07c9e:Authentication:requested:1620208855'
    end

    it 'encrypts properly' do
      encrypted = validator.calculate_notification_hmac(notification_request_item, key)
      expect(encrypted).to eq expected_sign
    end

    it 'has a valid hmac' do
      expect(validator).to be_valid_notification_hmac(notification_request_item, key)
    end

    it 'has an invalid hmac' do
      notification_request_item[:payload] = { hmac_signature: 'invalidHMACsign' }

      expect(validator).not_to be_valid_notification_hmac(notification_request_item, key)
    end
  end
end
