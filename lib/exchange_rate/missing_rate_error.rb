# frozen_string_literal: true

module ExchangeRate
  ##
  # Represents a cache-miss when requesting an FX
  # rate.
  class MissingRateError < StandardError; end
end
