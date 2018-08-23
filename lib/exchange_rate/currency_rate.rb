# frozen_string_literal: true

require 'active_record'

module ExchangeRate
  class CurrencyRate < ActiveRecord::Base
    validates :currency, presence: true
    validates :value_in_euro, presence: true
    validates :date_of_rate, presence: true
  end
end
