# frozen_string_literal: true

# Largely based on https://brandonhilkert.com/blog/ruby-gem-configuration-patterns/
RSpec.describe ExchangeRate::Configuration do
  describe '#rate_retriever' do
    it 'uses the ECB retriever by default' do
      expect(subject.rate_retriever.class).to eq(ExchangeRate::RateSources::ECBRateRetriever)
    end
  end

  describe '#rate_retriever=' do
    it 'can set value' do
      subject.rate_retriever = 'Arbitrary Value'
      expect(subject.rate_retriever).to eq('Arbitrary Value')
    end
  end

  describe '#datastore_url' do
    it 'uses a local SQLite3 connection by default' do
      expect(subject.datastore_url).to eq('sqlite://db/data.sqlite3')
    end
  end

  describe '#datastore_url=' do
    it 'can set value' do
      subject.datastore_url = 'Arbitrary Value'
      expect(subject.datastore_url).to eq('Arbitrary Value')
    end
  end
end
