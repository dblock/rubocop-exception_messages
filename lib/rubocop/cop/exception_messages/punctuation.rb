# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks the trailing punctuation of raised exception messages. By
      # default, disallows a trailing period, consistent with Ruby's own
      # core and standard library exceptions (e.g. `ArgumentError: wrong
      # number of arguments`). Configure `EnforcedStyle: period` to require
      # the opposite convention instead. A literal ellipsis (`"..."`) is
      # never considered an offense, since it's stylistic rather than a
      # sentence-ending period.
      #
      # @example EnforcedStyle: no_period (default)
      #   # bad
      #   raise ArgumentError, "block is required."
      #
      #   # good
      #   raise ArgumentError, "block is required"
      #
      # @example EnforcedStyle: period
      #   # bad
      #   raise ArgumentError, "block is required"
      #
      #   # good
      #   raise ArgumentError, "block is required."
      class Punctuation < Base
        include ConfigurableEnforcedStyle
        include MessageNode
        extend AutoCorrector

        MSG_NO_PERIOD = 'Exception messages should not end with a period.'
        MSG_PERIOD = 'Exception messages should end with a period.'

        def on_send(node)
          message_node = raise_message_node(node)
          return unless message_node

          last_segment = last_string_segment(message_node)
          return unless last_segment

          check_segment(message_node, last_segment)
        end

        private

        def check_segment(message_node, segment)
          content = segment.value.chomp("\n")
          return if content.end_with?('..') # ellipsis-style, not a sentence-ending period

          if style == :no_period
            check_no_period(message_node, segment, content)
          else
            check_period(message_node, segment, content)
          end
        end

        def check_no_period(message_node, segment, content)
          return unless content.end_with?('.')

          add_offense(message_node, message: MSG_NO_PERIOD) do |corrector|
            corrected = content.sub(/\.\z/, '')
            replace_content(corrector, segment, content, corrected)
          end
        end

        def check_period(message_node, segment, content)
          return if content.empty? || content.end_with?('.')

          add_offense(message_node, message: MSG_PERIOD) do |corrector|
            corrected = "#{content}."
            replace_content(corrector, segment, content, corrected)
          end
        end

        def replace_content(corrector, segment, content, corrected)
          range = segment.loc.respond_to?(:heredoc_body) ? segment.loc.heredoc_body : segment.loc.expression
          corrector.replace(range, range.source.sub(content, corrected))
        end

        def last_string_segment(message_node)
          segment = message_node.str_type? ? message_node : message_node.child_nodes.last
          segment if segment&.str_type?
        end
      end
    end
  end
end
