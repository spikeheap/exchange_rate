require "bundler/setup"
require 'simplecov'

# We need to start simplecov *before* we load our code
SimpleCov.start do
  add_filter %r{^/spec/}
end

require "exchange_rate"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
