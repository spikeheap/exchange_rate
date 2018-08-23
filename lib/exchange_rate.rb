require "exchange_rate/currency_converter"
require "exchange_rate/currency_rate"
require "exchange_rate/database_connection"
require "exchange_rate/missing_rate_error"
require "exchange_rate/retrieval_failed_error"
require "exchange_rate/rate_sources/e_c_b_rate_retriever"
require "exchange_rate/version"

module ExchangeRate
  # Retrieve the remote FX rate feed, and cache locally
  def self.retrieve
    # TODO refactor
    ExchangeRate::DatabaseConnection.connect

    # We expect all rate retrievers to be nice and return ExchangeRate::RetrievalFailed
    # but we'll catch everything here to safeguard against custom providers' errors
    # bubbling up to the caller
    begin
      ExchangeRate::RateSources::ECBRateRetriever.new.save!
    rescue
      raise ExchangeRate::RetrievalFailedError
    end

  end

  def self.at(date_of_rate, from_currency, to_currency)
    begin
      ExchangeRate::CurrencyConverter.new(date_of_rate, from_currency, to_currency).convert!
    rescue
      raise ExchangeRate::MissingRateError
    end
  end
end
