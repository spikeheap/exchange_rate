# frozen_string_literal: true

require 'exchange_rate/module_methods'

require 'exchange_rate/configuration'
require 'exchange_rate/currency_converter'
require 'exchange_rate/currency_rate'
require 'exchange_rate/database_connection'
require 'exchange_rate/initializers/sequel'
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
# Examples
#
#   # Retrieve the latest feed data & update the cache
#   ExchangeRate.retrieve
#
#   # Convert currencies
#   ExchangeRate.at(Date.today,'GBP','USD')
#   # => 0.12883019198912e1
#
module ExchangeRate; end
