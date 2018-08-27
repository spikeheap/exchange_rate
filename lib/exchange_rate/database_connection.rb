# frozen_string_literal: true
require 'sequel'
require 'sequel/extensions/migration'
require 'yaml'

module ExchangeRate
  ##
  # Database connection management for ::ExchangeRate.
  class DatabaseConnection
    ##
    # Establish a connection to the database, and ensure the schema is
    # loaded. The connection is cached and kept open.
    #
    # Returns nothing
    def self.connection
        # TODO: customisable path
        @connection ||= Sequel.connect('sqlite://db/data.sqlite3').tap{ |connection| apply_migrations(connection) }
    end

    ##
    # Closes any open connections to the database
    def self.disconnect
      @connection.disconnect unless @connection.nil?
    end

    ##
    # Apply the schema definitions to the database.
    # 
    # Returns nothing
    def self.apply_migrations(connection)
      Sequel::Migrator.run(connection, 'lib/exchange_rate/db/migrate/')
    end
  end
end
