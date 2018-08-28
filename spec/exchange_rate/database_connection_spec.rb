# frozen_string_literal: true

RSpec.describe ExchangeRate::DatabaseConnection do
  describe '#connection' do
    around do |example|
      # Disconnect everything so we can start a new connection
      described_class.disconnect

      example.run

      # Cleanup
      described_class.disconnect
    end

    it 'connects to the local cache' do
      expect(Sequel).to receive(:connect)
      described_class.connection
    end

    it 'reuses the connection object' do
      existing_connection = described_class.connection

      # expect it to not connect again
      expect(Sequel).to_not receive(:connect)
      expect(described_class.connection).to eq(existing_connection)
    end

    it 'uses the Configuration object datastore URL' do
      custom_datastore_url = 'sqlite://db/custom.sqlite3'

      ExchangeRate.configure do |configuration|
        configuration.datastore_url = custom_datastore_url
      end

      expect(Sequel).to receive(:connect).with(custom_datastore_url).and_call_original
      described_class.connection
    end
  end

  describe '#disconnect' do
    it 'disconnects the current connetion' do
      connection = described_class.connection
      expect(connection).to receive(:disconnect)
      expect(described_class.disconnect).to be_nil
    end

    it 'noops if no connection exists' do 
      expect(described_class.disconnect).to be_nil
    end
  end

  describe '#apply_migrations' do
    it 'applies the migrations' do
      connection = described_class.connection
      expect(Sequel::Migrator).to receive(:run).with(connection, 'lib/exchange_rate/db/migrate/')
      described_class.apply_migrations(connection)
    end
  end
end
