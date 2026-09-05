# frozen_string_literal: true

require 'lint_roller'

module RuboCop
  module ExceptionMessages
    # A plugin that integrates RuboCop ExceptionMessages with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-exception_messages',
          version: VERSION,
          homepage: 'https://github.com/dblock/rubocop-exception_messages',
          description: 'RuboCop cops that standardize the style of raised exception messages.'
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        project_root = Pathname.new(__dir__).join('../../..')

        LintRoller::Rules.new(type: :path, config_format: :rubocop, value: project_root.join('config', 'default.yml'))
      end
    end
  end
end
