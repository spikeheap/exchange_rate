# frozen_string_literal: true

class CreateCurrencyRates < Sequel::Migration
  def up
    create_table(:currency_rates) do |_t|
      primary_key :id
      String :currency, null: false
      BigDecimal :value_in_euro, null: false
      Date  :date_of_rate, null: false

      index %i[currency date_of_rate], unique: true
    end
  end

  def down
    self << 'DROP TABLE currency_rates'
  end
end
