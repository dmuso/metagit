require 'yaml'

module Metagit
  def self.config
    @@config ||= YAML.load_file('config/metagit.yml')
  end
end
