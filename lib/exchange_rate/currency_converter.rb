# frozen_string_literal: true

module ExchangeRate
  ##
  # Convert between currencies, using the local cache store
  #
  # Examples
  #
  #   CurrencyConverter.new(Date.today, 'GBP', 'USD').convert!
  #   # => 1.291700027
  #
  class CurrencyConverter
    ##
    # Builds a CurrencyConverter. The cache is not accessed on initialization.
    #
    # date_of_rate    - The date the rate should be used, for historical conversions.
    # source_currency - The source currency code, e.g. 'GBP'.
    # target_currency - The target currency code, e.g. 'USD'.
    def initialize(date_of_rate, source_currency, target_currency)
      @date_of_rate = date_of_rate
      @source_currency = source_currency
      @target_currency = target_currency
    end

    ##
    # Convert between the source and target currencies.
    # By default this will take 1 unit of the source currency.
    #
    # source_value - The number of units of source currency to convert.
    #
    # Examples
    #
    #   converter = CurrencyConverter.new(Date.today, 'GBP', 'USD')
    #
    #   converter.convert
    #   # => 1.291700027
    #
    #   converter.convert(source_value: 2)
    #   # => 2.583400054
    #
    def convert!(source_value: 1)
      (source_value / source_rate) * target_rate
    end

    ##
    # The (cached) source ExchangeRate::CurrencyRate object.
    #
    # Returns ExchangeRate::CurrencyRate.
    #
    # Raises ExchangeRate::MissingRateError if a cached rate does not exist.
    def source_rate
      find_currency_rate(@source_currency, @date_of_rate).value_in_euro
    end

    ##
    # The (cached) source ExchangeRate::CurrencyRate object.
    #
    # Returns ExchangeRate::CurrencyRate.
    #
    # Raises ExchangeRate::MissingRateError if a cached rate does not exist.
    def target_rate
      find_currency_rate(@target_currency, @date_of_rate).value_in_euro
    end

    private

    ##
    # Finds a currency rate
    #
    # Returns ExchangeRate::CurrencyRate.
    #
    # Raises ExchangeRate::MissingRateError if a cached rate does not exist.
    def find_currency_rate(currency, date_of_rate)
      CurrencyRate.first(currency: currency, date_of_rate: date_of_rate)
                  .tap { |rate| raise ExchangeRate::MissingRateError if rate.nil? }
    end
  end
end
