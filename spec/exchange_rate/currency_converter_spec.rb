# frozen_string_literal: true

RSpec.describe ExchangeRate::CurrencyConverter do
  let(:fx_rate_date) { Date.parse('2018-08-22') }
  let(:source_rate) { ExchangeRate::CurrencyRate.create!(date_of_rate: fx_rate_date, currency: 'GBP', value_in_euro: 0.89928) }
  let(:target_rate) { ExchangeRate::CurrencyRate.create!(date_of_rate: fx_rate_date, currency: 'USD', value_in_euro: 1.1616) }
  let(:subject) { described_class.new(fx_rate_date, 'GBP', 'USD') }

  describe '#convert!' do
    it 'converts 1 unit by default' do
      source_rate # ensure source rate is created
      target_rate # ensure target rate is created

      expected_target_value = (1 / source_rate.value_in_euro) * target_rate.value_in_euro
      expect(subject.convert!).to eq(expected_target_value)
    end

    it 'converts arbitrary amounts of currency' do
      source_rate # ensure source rate is created
      target_rate # ensure target rate is created

      expected_target_value = (5 / source_rate.value_in_euro) * target_rate.value_in_euro
      expect(subject.convert!(source_value: 5)).to eq(expected_target_value)
    end

    it 'raises ExchangeRate::MissingRateError when there is no cached source rate' do
      target_rate # ensure target rate is created
      expect { subject.convert! }.to raise_error(ExchangeRate::MissingRateError)
    end

    it 'raises ExchangeRate::MissingRateError when there is no cached target rate' do
      source_rate # ensure source rate is created
      expect { subject.convert! }.to raise_error(ExchangeRate::MissingRateError)
    end
  end

  describe '#source_rate' do
    it 'returns the locally cached exchange rate' do
      source_rate # ensure source rate is created
      expect(subject.source_rate).to eq(source_rate.value_in_euro)
    end

    it 'raises ExchangeRate::MissingRateError when there is no cached value' do
      expect { subject.source_rate }.to raise_error(ExchangeRate::MissingRateError)
    end
  end

  describe '#target_rate' do
    it 'returns the locally cached exchange rate' do
      target_rate # ensure target rate is created
      expect(subject.target_rate).to eq(target_rate.value_in_euro)
    end

    it 'raises ExchangeRate::MissingRateError when there is no cached value' do
      expect { subject.target_rate }.to raise_error(ExchangeRate::MissingRateError)
    end
  end
end
