# frozen_string_literal: true

##
# Module Methods for ExchangeRate.
# 
#--
# These methods are here because the configuration methods are needed in other classes which are
# required above the ExchangeRate module definition. It felt cleaner to move the module methods
# here than shift the module definition above the require statements.
# 
# Note: this defines methods on the module rather than providing a mixin because the latter still
# required the mixin to be included in the module of any class which referenced it. That might be
# cleaner in the long run.
#++
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
  # Set the configuration object used by this module.
  #
  # See ExchangeRate::Configuration.
  def self.configuration=(configuration)
    @configuration = configuration
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
