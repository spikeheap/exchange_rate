require 'date'

# These are the high-level acceptance tests
# for ExchangeRate
RSpec.describe ExchangeRate, :vcr do
  # This date references a value in the VCR for the tests, and will
  # likely need updating when the VCR is re-recorded
  let(:fx_rate_date) { Date.parse('2018-08-22') }

  it "has a version number" do
    expect(ExchangeRate::VERSION).not_to be nil
  end

  describe "#at" do
    it 'uses the local cache of the feed values' do
      source = ExchangeRate::CurrencyRate.create!(date_of_rate: fx_rate_date, currency: 'GBP', value_in_euro: 0.89928)
      target = ExchangeRate::CurrencyRate.create!(date_of_rate: fx_rate_date, currency: 'USD', value_in_euro: 1.1616)

      expected_value = (1 / source.value_in_euro) * target.value_in_euro
      expect(ExchangeRate.at(fx_rate_date,'GBP','USD')).to eq(expected_value)
    end

    it 'raises ExchangeRate::MissingRateError when the requested value does not exist locally' do
      expect do
        ExchangeRate.at(Date.today,'GBP','USD')
      end.to raise_error(ExchangeRate::MissingRateError)
    end
  end

  describe "#retrieve" do
    it 'fetches the feed and stores the values locally' do
      ExchangeRate.retrieve

      # Check the right number of records were saved (32 currencies * 90 working days)
      # The ECB feed doesn't include records for weekends.
      expect(ExchangeRate::CurrencyRate.count).to eq(2048)

      # Spot check a couple of values
      expect(ExchangeRate::CurrencyRate.find_by(date_of_rate: fx_rate_date, currency: 'GBP').value_in_euro).to eq(0.89928)
      expect(ExchangeRate::CurrencyRate.find_by(date_of_rate: fx_rate_date, currency: 'USD').value_in_euro).to eq(1.1616)
    end

    it 'overwrites existing values' do
      ExchangeRate::CurrencyRate.create!(date_of_rate: fx_rate_date, currency: 'USD', value_in_euro: 100)
      ExchangeRate.retrieve

      expect(ExchangeRate::CurrencyRate.find_by(date_of_rate: fx_rate_date, currency: 'USD').value_in_euro).to eq(1.1616)
    end

    xit 'raises ExchangeRate::RetrievalFailed when the the feed cannot be retrieved' do
    end
  end

  describe "configure" do
    xit 'can use a custom database connection' do
    end

    xit 'can use a custom FX rate provider' do
    end
  end


  
end
