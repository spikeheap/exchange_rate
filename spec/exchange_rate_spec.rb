# frozen_string_literal: true

require 'date'

# These are the high-level acceptance tests
# for ExchangeRate
RSpec.describe ExchangeRate, :vcr do
  # This date references a value in the VCR for the tests, and will
  # likely need updating when the VCR is re-recorded
  let(:fx_date) { Date.parse('2018-08-22') }

  it 'has a version number' do
    expect(ExchangeRate::VERSION).not_to be nil
  end

  describe '#at' do
    it 'uses the local cache of the feed values' do
      source = ExchangeRate::CurrencyRate.create(date_of_rate: fx_date, currency: 'GBP', value_in_euro: 0.89928)
      target = ExchangeRate::CurrencyRate.create(date_of_rate: fx_date, currency: 'USD', value_in_euro: 1.1616)

      expected_value = (1 / source.value_in_euro) * target.value_in_euro
      expect(ExchangeRate.at(fx_date, 'GBP', 'USD')).to eq(expected_value)
    end

    it 'raises ExchangeRate::MissingRateError when the requested value does not exist locally' do
      expect do
        ExchangeRate.at(Date.today, 'GBP', 'USD')
      end.to raise_error(ExchangeRate::MissingRateError)
    end
  end

  describe '#retrieve' do
    it 'fetches the feed and stores the values locally' do
      ExchangeRate.retrieve

      # Check the right number of records were saved (32 currencies * 90 working days)
      # The ECB feed doesn't include records for weekends.
      expect(ExchangeRate::CurrencyRate.count).to eq(2048)

      # Spot check a couple of values
      expect(ExchangeRate::CurrencyRate.first(date_of_rate: fx_date, currency: 'GBP').value_in_euro).to eq(0.89928)
      expect(ExchangeRate::CurrencyRate.first(date_of_rate: fx_date, currency: 'USD').value_in_euro).to eq(1.1616)
    end

    it 'overwrites existing values' do
      ExchangeRate::CurrencyRate.create(date_of_rate: fx_date, currency: 'USD', value_in_euro: 100)
      ExchangeRate.retrieve

      expect(ExchangeRate::CurrencyRate.first(date_of_rate: fx_date, currency: 'USD').value_in_euro).to eq(1.1616)
    end

    it 'raises ExchangeRate::RetrievalFailed when the the feed cannot be retrieved' do
      ExchangeRate.configure do |config|
        config.rate_retriever = ExchangeRate::RateSources::ECBRateRetriever.new(feed_url: 'https://example.com')
      end

      expect do
        ExchangeRate.retrieve
      end.to raise_error(ExchangeRate::RetrievalFailedError)
    end
  end

  describe '#configure' do
    it 'can use a custom FX rate provider' do
      custom_retriever = 'An arbitrary thing'
      ExchangeRate.configure do |config|
        config.rate_retriever = custom_retriever
      end

      expect(ExchangeRate.configuration.rate_retriever).to eq(custom_retriever)
    end
  end

  describe '#configuration=' do
    it 'sets the Configuration object' do
      new_value = 'Arbitrary Thing'
      ExchangeRate.configuration = new_value
      expect(ExchangeRate.configuration).to eq(new_value)
    end
  end
end
