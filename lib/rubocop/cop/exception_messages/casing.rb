# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks that raised exception messages start with a lowercase letter,
      # consistent with Ruby's own core and standard library exceptions
      # (e.g. `TypeError: no implicit conversion from nil to integer`).
      #
      # @example
      #   # bad
      #   raise ArgumentError, "Block is required"
      #   raise ArgumentError.new("Block is required")
      #
      #   # good
      #   raise ArgumentError, "block is required"
      #   raise ArgumentError.new("block is required")
      class Casing < Base
        include MessageNode
        extend AutoCorrector

        MSG = 'Exception messages should start with a lowercase letter.'

        def on_send(node)
          message_node = raise_message_node(node)
          return unless message_node

          first_segment = first_string_segment(message_node)
          return unless first_segment

          content = first_segment.value
          return if content.empty? || content[0] !~ /[A-Z]/

          add_offense(message_node) do |corrector|
            corrected = content.sub(/\A./, &:downcase)
            corrector.replace(first_segment.loc.expression, first_segment.source.sub(content, corrected))
          end
        end

        private

        def first_string_segment(message_node)
          segment = message_node.str_type? ? message_node : message_node.child_nodes.first
          segment if segment&.str_type?
        end
      end
    end
  end
end
