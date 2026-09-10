# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks that a raised exception message has an appropriate length and
      # is not a generic message.
      #
      # `GenericMessages` is a configurable, case-insensitive list of exact
      # messages or regular expressions. `MinimumLength` controls the minimum
      # number of characters required in every message. `MaximumLength`
      # controls the maximum number of characters allowed.
      # `MinimumWords` and `MaximumWords` control the allowed word count.
      # `Exceptions` can override these settings for specific exception
      # classes.
      #
      # @example
      #   # bad
      #   raise ArgumentError, "invalid"
      #   raise StandardError, "error"
      #   raise RuntimeError, "failed"
      #
      #   # good
      #   raise ArgumentError, "invalid type: `#{type}`"
      #   raise StandardError, "error connecting to the database"
      #   raise RuntimeError, "failed to acquire lock"
      class NoGenericMessage < Base
        include MessageNode

        MSG = 'Exception message should contain at least %<minimum_length>d characters.'
        MAX_MSG = 'Exception message should contain at most %<maximum_length>d characters.'
        WORDS_MSG = 'Exception message should contain at least %<minimum_words>d words.'
        MAX_WORDS_MSG = 'Exception message should contain at most %<maximum_words>d words.'
        GENERIC_MESSAGE = 'Exception message is too generic, add more context.'

        def on_send(node)
          inspect_message(node)
        end

        def on_super(node)
          inspect_message(node)
        end

        private

        def inspect_message(node)
          message_node = raise_message_node(node)
          return unless message_node
          return unless message_node.str_type?

          content = message_node.value.strip
          config = exception_config(node)
          return unless invalid?(content, config)

          add_offense(message_node, message: offense_message(content, config))
        end

        def too_short?(content, config)
          minimum_length(config) && content.length < minimum_length(config)
        end

        def too_long?(content, config)
          maximum_length(config) && content.length > maximum_length(config)
        end

        def too_few_words?(content, config)
          minimum_words(config) && word_count(content) < minimum_words(config)
        end

        def too_many_words?(content, config)
          maximum_words(config) && word_count(content) > maximum_words(config)
        end

        def invalid?(content, config)
          generic?(content, config) ||
            too_short?(content, config) ||
            too_long?(content, config) ||
            too_few_words?(content, config) ||
            too_many_words?(content, config)
        end

        def offense_message(content, config)
          return format(MSG, minimum_length: minimum_length(config)) if too_short?(content, config)
          return format(MAX_MSG, maximum_length: maximum_length(config)) if too_long?(content, config)
          return format(WORDS_MSG, minimum_words: minimum_words(config)) if too_few_words?(content, config)
          return format(MAX_WORDS_MSG, maximum_words: maximum_words(config)) if too_many_words?(content, config)

          GENERIC_MESSAGE
        end

        def minimum_length(config)
          config.fetch('MinimumLength') { cop_config['MinimumLength'] }
        end

        def maximum_length(config)
          config.fetch('MaximumLength') { cop_config['MaximumLength'] }
        end

        def minimum_words(config)
          config.fetch('MinimumWords') { cop_config.fetch('MinimumWords', 1) }
        end

        def maximum_words(config)
          config.fetch('MaximumWords') { cop_config['MaximumWords'] }
        end

        def word_count(content)
          content.split.length
        end

        def generic?(content, config)
          generic_messages(config).any? do |message|
            generic_message_match?(message, content)
          end
        end

        def generic_messages(config)
          config.fetch('GenericMessages') { cop_config['GenericMessages'] || [] }
        end

        def exception_config(node)
          exception_name = raised_exception_name(node)
          return {} unless exception_name

          exceptions = cop_config['Exceptions'] || {}
          exceptions[exception_name] || exceptions[exception_name.split('::').last] || {}
        end

        def raised_exception_name(node)
          raised_class_node(node)&.const_name
        end

        def raised_class_node(node)
          first_arg = node.arguments.first
          return unless first_arg

          return first_arg.receiver if first_arg.send_type? && first_arg.method?(:new)

          first_arg
        end

        def generic_message_match?(message, content)
          regexp = regexp_from(message)
          regexp ? regexp.match?(content) : message.casecmp?(content)
        end

        def regexp_from(message)
          match = message.match(%r{\A/(.*)/([imx]*)\z})
          return unless match

          flags = 0
          flags |= Regexp::IGNORECASE if match[2].include?('i')
          flags |= Regexp::MULTILINE if match[2].include?('m')
          flags |= Regexp::EXTENDED if match[2].include?('x')
          Regexp.new(match[1], flags)
        end
      end
    end
  end
end
