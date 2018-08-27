# frozen_string_literal: true
require 'sequel'
require 'exchange_rate/database_connection'

module ExchangeRate
  ##
  # A currency/rate/date tuple. Represents the
  # value of the currency on a specific date, in Euro
  # Examples
  #
  #   CurrencyRate.new(currency = 'GBP',
  #                    value_in_euro = 0.001,
  #                    date_of_rate = Date.parse('2019-03-30'))
  #
  class CurrencyRate < Sequel::Model(DatabaseConnection.connection[:currency_rates])
    ##
    # :attr_writer: currency
    # The currency short-code String

    ##
    # :attr_writer: value_in_euro
    # The value of one unit of the currency in Euro

    ##
    # :attr_writer: date_of_rate
    # The effective date of this FX rate for the currency
    
    def validate
      super
      validates_presence [:currency, :value_in_euro, :date_of_rate]
    end
  end
end
