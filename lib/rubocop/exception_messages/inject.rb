# frozen_string_literal: true

module RuboCop
  module ExceptionMessages
    # Injects RuboCop ExceptionMessages cops configuration
    # into RuboCop's config so it merges with the user's own `.rubocop.yml`.
    module Inject
      def self.defaults!
        path = CONFIG_DEFAULT
        hash = ConfigLoader.load_file(path)
        config = Config.new(hash, path).tap(&:make_excludes_absolute)
        puts "configuration from #{path}" if ConfigLoader.debug?
        config = ConfigLoader.merge_with_default(config, path)
        ConfigLoader.instance_variable_set(:@default_configuration, config)
      end
    end
  end
end
