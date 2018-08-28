# frozen_string_literal: true

RSpec.describe ExchangeRate::DatabaseConnection do
  describe '#connection' do
    # TODO

    around do |example|
      # Disconnect everything so we can start a new connection
      described_class.disconnect

      example.run

      # Cleanup
      described_class.disconnect
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
    # TODO
  end

  describe '#apply_schema' do
    # TODO
  end
end
