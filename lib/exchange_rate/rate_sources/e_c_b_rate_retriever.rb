# frozen_string_literal: true

require 'active_support/core_ext/hash/conversions.rb'
require 'net/http'
require 'uri'

module ExchangeRate
  module RateSources
    class ECBRateRetriever
      DEFAULT_FEED_URL = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'

      def initialize(feed_url: DEFAULT_FEED_URL)
        @feed_url = feed_url
      end

      # Raises ExchangeRate::RetrievalFailed
      # TODO: doc save does n calls to DB, so could be optimised
      def save!
        retrieve_feed
          .yield_self { |feed_body| parse_feed(feed_body) }
          .map(&:save!)
      rescue StandardError
        raise ExchangeRate::RetrievalFailedError
      end

      private

      def retrieve_feed
        uri = URI.parse(@feed_url)
        Net::HTTP.get_response(uri).body
      end

      def parse_feed(feed_body)
        Hash.from_xml(feed_body)
            .yield_self { |feed_hash| rate_array_from(feed_hash) }
            .map { |rate_date_hash| rates_from(rate_date_hash, date_from(rate_date_hash)) }
            .flatten
      end

      # TODO: - doc hash fetchers
      def rate_array_from(feed_hash)
        feed_hash['Envelope']['Cube']['Cube']
      end

      def date_from(rate_date_hash)
        Date.parse(rate_date_hash['time'])
      end

      def rates_from(rate_date_hash, rate_effective_date)
        rate_date_hash['Cube'].map do |currency_rate_hash|
          build_currency_rate(currency: currency_rate_hash['currency'],
                              value_in_euro: currency_rate_hash['rate'].to_d,
                              date_of_rate: rate_effective_date)
        end
      end

      def build_currency_rate(currency:, value_in_euro:, date_of_rate:)
        rate = CurrencyRate.find_or_initialize_by(currency: currency, date_of_rate: date_of_rate)
        rate.value_in_euro = value_in_euro
        rate.tap(&:save!)
      end
    end
  end
end
