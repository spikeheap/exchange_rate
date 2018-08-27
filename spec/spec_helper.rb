# frozen_string_literal: true

require 'bundler/setup'
require 'database_cleaner'
require 'simplecov'
require 'vcr'
# FIXME: refactor into multiple files

# We need to start simplecov *before* we load our code
SimpleCov.start do
  add_filter %r{^/spec/}
end

require 'exchange_rate'

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

VCR.configure do |config|
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    allow_unused_http_interactions: false
  }
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
end
