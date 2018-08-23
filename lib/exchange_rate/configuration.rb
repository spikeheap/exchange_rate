module ExchangeRate
  # Largely based on https://brandonhilkert.com/blog/ruby-gem-configuration-patterns/
  class Configuration

    # Return the default ECB retriever unless one has been set
    def rate_retriever
      @rate_retriever || ExchangeRate::RateSources::ECBRateRetriever.new
    end

    def rate_retriever=(rate_retriever)
      @rate_retriever = rate_retriever
    end
  end
end