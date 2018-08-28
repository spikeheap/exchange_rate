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
      @rate_retriever ||= ExchangeRate::RateSources::ECBRateRetriever.new
    end

    ##
    # The rate retriever to use for (e.g. ExchangeRate.retrieve)
    attr_writer :rate_retriever

    ##
    # Gets the local cache database URL, defaulting to a local SQLite3 file.
    #
    # Returns the local cache URL.
    def datastore_url
      @datastore_url ||= 'sqlite://db/data.sqlite3'
    end

    ##
    # The local cache database URL, e.g. 'sqlite://db/data.sqlite3'
    attr_writer :datastore_url
  end
end
