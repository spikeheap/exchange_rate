# frozen_string_literal: true

require 'active_support/core_ext/hash/conversions.rb'
require 'net/http'
require 'sequel/exceptions'
require 'uri'

module ExchangeRate
  module RateSources
    ##
    # Retrieves FX rates from the 90 day European Central Bank (ECB) feed.
    class ECBRateRetriever
      ##
      # The ECB feed URL
      DEFAULT_FEED_URL = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'

      ##
      # Builds a new ECBRateRetriever.
      #
      # - feed_url - The URL to request the ECB feed from.
      def initialize(feed_url: DEFAULT_FEED_URL)
        @feed_url = feed_url
      end

      ##
      # Retrieve the feed, parse the contents, and update the local cache.
      #
      # Returns nothing
      # Raises ExchangeRate::RetrievalFailedError if the feed could not be loaded
      # Raises ExchangeRate::RetrievalFailedError if the cache could not be updated
      #--
      # TODO: This makes 1 database call per record to be saved. A bulk-insert would speed
      #       things up considerably.
      #++
      def save!
        retrieve_feed
          .yield_self { |feed_body| parse_feed(feed_body) }
          .map { |rate_date_hash| rates_from(rate_date_hash, date_from(rate_date_hash)) }
          .flatten
          .map(&:save)
        nil
      rescue StandardError
        raise ExchangeRate::RetrievalFailedError
      end

      private

      ##
      # Perform the HTTP request to grab the feed contents.
      #
      # Returns the response body as a String.
      def retrieve_feed
        uri = URI.parse(@feed_url)
        Net::HTTP.get_response(uri).body
      end

      ##
      # Parse the ECB feed XML into an array of feed ::Hash objects.
      #
      # feed_body - The XML ECB feed document as a String.
      #
      # Returns an array of currency/date/rate ::Hash objects, grouped by date (see #rate_array_from).
      def parse_feed(feed_body)
        Hash.from_xml(feed_body)
            .yield_self { |feed_hash| rate_array_from(feed_hash) }
      end

      ##
      # Extract the array of FX rates from the XML document.
      #
      # feed_hash - A ::Hash representation of the XML ECB feed document.
      #
      # Returns An array of date/rate/currency ::Hash objects, grouped by date.
      def rate_array_from(feed_hash)
        feed_hash['Envelope']['Cube']['Cube']
      end

      ##
      # Extract the effective date of an FX rate.
      #
      # rate_date_hash - A single currency/date/rate ::Hash object.
      #
      # Returns the effective ::Date of the FX rate.
      def date_from(rate_date_hash)
        Date.parse(rate_date_hash['time'])
      end

      ##
      # Builds an array of ExchangeRate::CurrencyRate objects.
      #
      # rate_date_array    - An array of currency/rate ::Hash objects
      # rate_effective_date - The effective ::Date for FX rates in the rate_date_hash.
      def rates_from(rate_date_array, rate_effective_date)
        rate_date_array['Cube'].map do |currency_rate_hash|
          create_or_update_currency_rate(currency: currency_rate_hash['currency'],
                                         value_in_euro: currency_rate_hash['rate'].to_f,
                                         date_of_rate: rate_effective_date)
        end
      end

      ##
      # Creates or updates the local cache of the currency/rate/date tuple
      #
      # currency      - The currency short-code, e.g. 'GBP'.
      # value_in_euro - The value of one unit (e.g. $1) in Euro.
      # date_of_rate  - The date this value applies to.
      #
      # Returns true if the record saved
      # Raises ExchangeRate::RetrievalFailedError if the record could not be saved
      def create_or_update_currency_rate(currency:, value_in_euro:, date_of_rate:)
        rate = CurrencyRate.find_or_new(currency: currency, date_of_rate: date_of_rate)
        rate.value_in_euro = value_in_euro
        rate.tap(&:save)
      rescue Sequel::ValidationFailed, Sequel::HookFailed
        raise ExchangeRate::RetrievalFailedError
      end
    end
  end
end
