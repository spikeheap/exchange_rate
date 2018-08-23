# frozen_string_literal: true

module ExchangeRate
  class CurrencyConverter
    def initialize(date_of_rate, source_currency, target_currency)
      @date_of_rate = date_of_rate
      @source_currency = source_currency
      @target_currency = target_currency
    end

    # Converts between the source and target currencies.
    # By default this will take 1 unit of the source currency
    def convert!(source_value: 1)
      (source_value / source_rate) * target_rate
    end

    def source_rate
      find_currency_rate(@source_currency, @date_of_rate).value_in_euro
    end

    def target_rate
      find_currency_rate(@target_currency, @date_of_rate).value_in_euro
    end

    private

    def find_currency_rate(currency, date_of_rate)
      CurrencyRate.find_by!(currency: currency, date_of_rate: date_of_rate)
    rescue ActiveRecord::RecordNotFound
      raise ExchangeRate::MissingRateError
    end
  end
end
