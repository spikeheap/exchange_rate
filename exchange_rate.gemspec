
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "exchange_rate/version"

Gem::Specification.new do |spec|
  spec.name          = "exchange_rate"
  spec.version       = ExchangeRate::VERSION
  spec.authors       = ["Ryan Brooks"]
  spec.email         = ["ryan@ryanbrooks.co.uk"]

  spec.summary       = %q{Retrieve and cache historical foreign exchange rates}
  spec.description   = %q{ExchangeRate uses a cache for FX rates so you're not dependent on a constant connection to your FX rate provider of choice, and allow custom FX rate providers to be added with ease.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "database_cleaner", "~> 1.7.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16.1"
  spec.add_development_dependency "rubocop", "~> 0.58.2"
  spec.add_development_dependency "vcr", "~> 4.0.0"
  spec.add_development_dependency "webmock", "~> 3.4.2"

  spec.add_development_dependency "pry", "~> 0.11.3"


  spec.add_dependency "activerecord", "~> 5.2.1"
  spec.add_dependency "activesupport", "~> 5.2.1"
  spec.add_dependency "sqlite3", "~> 1.3.13"
end
