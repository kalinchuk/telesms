require 'bundler/setup'
require 'simplecov'
require 'mail'

Bundler.setup

SimpleCov.start do
  coverage_dir 'doc/coverage'
  add_filter 'spec'
end

Mail.defaults do
  delivery_method :test
end

ENV["RAILS_ENV"] ||= 'test'

require 'telesms'
require 'rspec'
require 'rspec/autorun'
require 'faker'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  config.include Mail::Matchers
end
