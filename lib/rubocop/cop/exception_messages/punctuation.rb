# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks that raised exception messages do not end with a period,
      # consistent with Ruby's own core and standard library exceptions
      # (e.g. `ArgumentError: wrong number of arguments`).
      #
      # @example
      #   # bad
      #   raise ArgumentError, "block is required."
      #   raise ArgumentError.new("block is required.")
      #
      #   # good
      #   raise ArgumentError, "block is required"
      #   raise ArgumentError.new("block is required")
      class Punctuation < Base
        include MessageNode
        extend AutoCorrector

        MSG = 'Exception messages should not end with a period.'

        def on_send(node)
          message_node = raise_message_node(node)
          return unless message_node

          last_segment = last_string_segment(message_node)
          return unless last_segment

          check_segment(message_node, last_segment)
        end

        private

        def check_segment(message_node, segment)
          content = segment.value
          return unless content.end_with?('.')
          return if content.end_with?('..') # ellipsis-style, not a sentence-ending period

          add_offense(message_node) do |corrector|
            corrected = content.sub(/\.\z/, '')
            corrector.replace(segment.loc.expression, segment.source.sub(content, corrected))
          end
        end

        def last_string_segment(message_node)
          segment = message_node.str_type? ? message_node : message_node.child_nodes.last
          segment if segment&.str_type?
        end
      end
    end
  end
end
