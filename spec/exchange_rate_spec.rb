# These are the high-level acceptance tests
# for ExchangeRate
RSpec.describe ExchangeRate do
  it "has a version number" do
    expect(ExchangeRate::VERSION).not_to be nil
  end

  describe "#at" do
    xit 'uses the local cache of the feed values' do
    end

    xit 'raises ExchangeRate::NoData when the requested value does not exist locally' do
    end
  end

  describe "#retrieve" do
    xit 'fetches the feed and stores the values locally' do
    end

    xit 'overwrites existing values' do
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
