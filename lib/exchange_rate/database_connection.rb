# frozen_string_literal: true

require 'yaml'

module ExchangeRate
  ##
  # Database connection management for ::ExchangeRate.
  #--
  # FIXME: Remote AR. this won't play well with another AR instance.
  #++
  class DatabaseConnection
    ##
    # Establish a connection to the database, and ensure the schema is
    # loaded.
    #
    # Returns nothing
    #--
    # TODO: test
    # TODO: make into singleton
    #++
    def self.connect
      db_settings = YAML.load_file('db/database.yml')
      ActiveRecord::Base.establish_connection(db_settings[environment])

      apply_schema
      nil
    end

    ##
    # Apply the schema definitions to the database.
    #
    # *Warning* This destroys the existing database, which isn't so good
    # for production data...
    #
    # Returns nothing
    #--
    # FIXME: this won't stand up to much, it recreates each time
    # FIXME: but if we don't it tries to create and fails
    #++
    def self.apply_schema
      ActiveRecord::Schema.define do
        create_table(:currency_rates, force: true, timestamps: true) do |t|
          t.string  :currency, null: false
          t.decimal :value_in_euro, null: false
          t.date    :date_of_rate, null: false
        end
      end
    end

    ##
    # Retrieve the environment name from ENV.
    #
    # ENV can be set from outside Ruby.
    #
    # Examples
    #
    #   # defaults to 'development'
    #   ExchangeRate::DatabaseConnection.environment
    #   # => 'development'
    #
    #   ENV['environment'] = 'production'
    #   ExchangeRate::DatabaseConnection.environment
    #   # => 'production'
    #
    # Returns the environment name as a String
    def self.environment
      ENV['environment'] || 'development'
    end
  end
end
