require 'date'

# These are the high-level acceptance tests
# for ExchangeRate
RSpec.describe ExchangeRate do
  # This date references a value in the VCR for the tests, and will
  # likely need updating when the VCR is re-recorded
  let(:fx_rate_date) { Date.parse('2018-08-22') }

  it "has a version number" do
    expect(ExchangeRate::VERSION).not_to be nil
  end

  describe "#at" do
    it 'uses the local cache of the feed values' do
      expect(ExchangeRate.at(fx_rate_date,'GBP','USD')).to eq(1.291700027)
    end

    xit 'raises ExchangeRate::NoData when the requested value does not exist locally' do
    end
  end

  describe "#retrieve" do

    it 'fetches the feed and stores the values locally' do
      ExchangeRate.retrieve

      # Check the right number of records were saved (32 currencies * 90 days)
      expect(ExchangeRate::CurrencyRate.count).to eq(2880)

      # Spot check a couple of values
      expect(ExchangeRate::CurrencyRate.where(exchange_date: fx_rate_date, currency: 'USD')).to eq(1.1616)
      expect(ExchangeRate::CurrencyRate.where(exchange_date: fx_rate_date, currency: 'GBP')).to eq(0.89928)
    end

    xit 'overwrites existing values' do
    end

    xit 'raises ExchangeRate::RetrievalFailed when the the feed cannot be retrieved' do
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
