# frozen_string_literal: true

module ExchangeRate
  # Largely based on https://brandonhilkert.com/blog/ruby-gem-configuration-patterns/
  class Configuration
    # Return the default ECB retriever unless one has been set
    def rate_retriever
      @rate_retriever || ExchangeRate::RateSources::ECBRateRetriever.new
    end

    attr_writer :rate_retriever
  end
end
