lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telesms/version'

Gem::Specification.new do |spec|
  spec.name          = "telesms"
  spec.version       = Telesms::VERSION
  spec.authors       = ["Artem Kalinchuk"]
  spec.email         = ["artem9@gmail.com"]
  spec.description   =  "Library for sending and receiving SMS messages with emails."
  spec.summary       = "Send and received formatted SMS messages using email messages."
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "> 3.0.0"
  spec.add_dependency "mail"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "faker"
end
