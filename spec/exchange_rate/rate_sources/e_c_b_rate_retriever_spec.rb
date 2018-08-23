RSpec.describe ExchangeRate::RateSources::ECBRateRetriever, :vcr do
  # This date references a value in the VCR for the tests, and will
  # likely need updating when the VCR is re-recorded
  let(:fx_rate_date) { Date.parse('2018-08-22') }

  describe '#save!' do
    it 'retrieves the feed' do
      subject.save!

      # Check the right number of records were saved (32 currencies * 90 working days)
      # The ECB feed doesn't include records for weekends.
      expect(ExchangeRate::CurrencyRate.count).to eq(2048)

      # Spot check a couple of values.value_in_euro
      expect(ExchangeRate::CurrencyRate.find_by(date_of_rate: fx_rate_date, currency: 'USD').value_in_euro).to eq(1.1616)
      expect(ExchangeRate::CurrencyRate.find_by(date_of_rate: fx_rate_date, currency: 'GBP').value_in_euro).to eq(0.89928)
    end

    it 'raises when the feed URL is invalid' do
      expect do
        described_class.new(feed_url: 'httpt://example.com').save!
      end.to raise_exception(ExchangeRate::RetrievalFailedError)
    end

    it 'raises when the feed content is invalid' do
      expect do
        described_class.new(feed_url: 'http://example.com').save!
      end.to raise_exception(ExchangeRate::RetrievalFailedError)
    end
  end
end