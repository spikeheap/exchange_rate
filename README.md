# ExchangeRate

Retrieves foreign exchange (FX) rates. ExchangeRate uses a cache for FX rates so you're not dependent on a constant connection to your FX rate provider of choice.

ExchangeRate has a pluggable backend for FX rate providers, so custom providers can be added with ease. Currently, ExchangeRate supports the following data sources:

- (90 day European Central Bank (ECB) feed)[http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml]

> We'd love to hear what other sources you use, and welcome pull-requests with additional backends.

## Requirements

1. Ruby > 2.5.0

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'fx_exchange_rate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fx_exchange_rate

## Usage

```ruby
require 'exchange_rate'

# Retrieve the latest FX rates from the feed
ExchangeRate.retrieve

# Then get the FX rate from USD to GBP for yesterday
ExchangeRate.at(Date.yesterday,'USD','GBP')
```

## Local cache

Data is written to a local cache at `db/data.sqlite`. We use the [Sequel](https://github.com/jeremyevans/sequel) ORM, so any compatible database can be used. A custom database can be defined using:

```ruby
ExchangeRate.configure do |configuration|
  configuration.datastore_url = 'postgresql://user:password@localhost/exchangerate_db'
end
```

You will need to ensure that database exists. The schema will be automatically added by `ExchangeRate`.

## Adding a custom FX provider

Custom retrievers can be configured as follows:

> Note: Custom retrievers are expected to implement `save!`, and raise `ExchangeRate::RetrievalFailedError` if the retrieval fails.

```ruby
ExchangeRate.configure do |configuration|
  configuration.rate_retriever = MyCustomRetriever.new
end
```

See [the ECB rate retriever](lib/exchange_rate/rate_sources/e_c_b_rate_retriever.rb) for an example implementation.

## Refreshing data with cron
You'll probably want to refresh the cache at intervals. You can achieve this with the following script:

> Tip: All the script to be executed with `chmod +x my_script_name`.

```ruby
#!/usr/bin/env ruby

# Add any custom DB or retriever configuration here

# Retrieve the feed and update the cache
ExchangeRate.retrieve
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Documentation

Documentation can be generated using RDoc:

```bash
bundle exec rdoc
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/spikeheap/exchange_rate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ExchangeRate project’s codebases, issue trackers, chat rooms and mailing lists are expected to follow the [code of conduct](https://github.com/spikeheap/exchange_rate/blob/master/CODE_OF_CONDUCT.md).
