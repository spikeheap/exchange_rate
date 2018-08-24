# frozen_string_literal: true

require 'active_record'

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
  class CurrencyRate < ActiveRecord::Base
    ##
    # :attr_writer: currency
    # The currency short-code String
    validates :currency, presence: true

    ##
    # :attr_writer: value_in_euro
    # The value of one unit of the currency in Euro
    validates :value_in_euro, presence: true

    ##
    # :attr_writer: date_of_rate
    # The effective date of this FX rate for the currency
    validates :date_of_rate, presence: true
  end
end
