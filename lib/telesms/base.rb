module Telesms
  module Base
    def self.gateways
      YAML.load_file(File.join(File.dirname(__FILE__), '..', '..', 'config', 'gateways.yml'))
    end
  end
end

# Telesms::Base.gateways