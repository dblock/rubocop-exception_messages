# frozen_string_literal: true

module RuboCop
  # RuboCop cops for standardizing the style of raised exception messages.
  module ExceptionMessages
    PROJECT_ROOT = File.expand_path('../..', __dir__)
    CONFIG_DEFAULT = File.join(PROJECT_ROOT, 'config', 'default.yml')
    CONFIG = RuboCop::ConfigLoader.load_file(CONFIG_DEFAULT).freeze

    private_constant :PROJECT_ROOT, :CONFIG_DEFAULT
  end
end
