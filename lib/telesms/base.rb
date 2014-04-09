module Telesms
  # This module contains shared resources.
  module Base
    # This method retrieves all the gateways from the config file.
    #
    # @return [Hash]
    def self.gateways
      YAML.load_file(File.join(File.dirname(__FILE__), '..', '..', 'config', 'gateways.yml'))
    end
  end
end