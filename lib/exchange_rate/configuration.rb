# frozen_string_literal: true

module ExchangeRate
  ##
  # Stores configuration for the ::ExchangeRate module.
  #
  # See ::ExchangeRate for examples.
  #
  # Largely based on https://brandonhilkert.com/blog/ruby-gem-configuration-patterns/
  class Configuration
    ##
    # Gets the rate retriever, defaulting to the built-in ECB retriever.
    #
    # Returns the default ECB retriever unless one has been set
    def rate_retriever
      @rate_retriever || ExchangeRate::RateSources::ECBRateRetriever.new
    end

    ##
    # The rate retriever to use for (e.g. ExchangeRate.retrieve)
    attr_writer :rate_retriever
  end
end
