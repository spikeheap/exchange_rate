# frozen_string_literal: true

require 'yaml'

module ExchangeRate
  class DatabaseConnection
    # TODO: test
    # FIXME: this won't play well with another AR instance
    def self.connect
      db_settings = YAML.load_file('db/database.yml')
      ActiveRecord::Base.establish_connection(db_settings[environment])

      apply_schema
    end

    def self.apply_schema
      # FIXME: this won't stand up to much, it recreates each time
      # FIXME: but if we don't it tries to create and fails
      ActiveRecord::Schema.define do
        create_table(:currency_rates, force: true, timestamps: true) do |t|
          t.string  :currency, null: false
          t.decimal :value_in_euro, null: false
          t.date    :date_of_rate, null: false
        end
      end
    end

    def self.environment
      ENV['environment'] || 'development'
    end
  end
end
