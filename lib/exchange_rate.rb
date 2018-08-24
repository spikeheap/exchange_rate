# frozen_string_literal: true

require 'exchange_rate/configuration'
require 'exchange_rate/currency_converter'
require 'exchange_rate/currency_rate'
require 'exchange_rate/database_connection'
require 'exchange_rate/missing_rate_error'
require 'exchange_rate/rate_sources.rb'
require 'exchange_rate/rate_sources/e_c_b_rate_retriever'
require 'exchange_rate/retrieval_failed_error'
require 'exchange_rate/version'

##
# Retrieve and cache historical foreign exchange rates.
#
# ExchangeRate uses a cache for FX rates so you are not dependent on a constant connection to your
# FX rate provider of choice, and allow custom FX rate providers to be added with ease.
#
#--
# TODO remove DB connection line as soon as it's unnecessary
#++
# Examples
#
#   # Open a connection to the local cache
#   ExchangeRate::DatabaseConnection.conect
#
#   # Retrieve the latest feed data & update the cache
#   ExchangeRate.retrieve
#
#   # Convert currencies
#   ExchangeRate.at(Date.today,'GBP','USD')
#   # => 0.12883019198912e1
#
module ExchangeRate
  ##
  # Retrieve the remote FX rate feed and cache locally.
  #
  # Returns nothing.
  #
  # Raises ExchangeRate::RetrievalFailedError if the retrieval fails or the cache cannot be updated.
  def self.retrieve
    configuration.rate_retriever.save!
    nil
  # We expect all rate retrievers to be nice and return ExchangeRate::RetrievalFailed
  # but we'll catch everything here to safeguard against custom providers' errors
  # bubbling up to the caller
  rescue StandardError
    raise ExchangeRate::RetrievalFailedError
  end

  ##
  # Converts from from_currency to to_currency using the FX rate
  # valid on the date_of_rate.
  #
  # date_of_rate  - The Date to use for conversion
  # from_currency - The source currency code String
  # from_currency - The target currency code String
  #
  # Examples
  #
  #   ExchangeRate.at(Date.today,'GBP','USD')
  #   # => 0.12883019198912e1
  #
  # Returns the value of 1 unit of from_currency in to_currency.
  #
  # Raises ExchangeRate::MissingRateError if the local cache cannot be accessed or the value has not been cached.
  def self.at(date_of_rate, from_currency, to_currency)
    ExchangeRate::CurrencyConverter.new(date_of_rate, from_currency, to_currency).convert!
  rescue StandardError
    raise ExchangeRate::MissingRateError
  end

  ##
  # The configuration object used by this module.
  #
  # See ExchangeRate::Configuration.
  #
  # Returns a singleton ExchangeRate::Configuration global configuration object.
  def self.configuration
    @configuration ||= Configuration.new
  end

  ##
  # Configures the ExchangeRate module with the provided block.
  #
  # See ExchangeRate::Configuration.
  #
  # Examples
  #
  #   ExchangeRate.configure do |configuration|
  #     configuration.rate_retriever = CustomRateRetriever.new
  #   end
  #
  # Returns nothing
  def self.configure
    yield(configuration)
  end
end
