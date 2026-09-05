# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks the capitalization of raised exception messages. By default,
      # requires a lowercase first letter, consistent with Ruby's own core
      # and standard library exceptions (e.g. `TypeError: no implicit
      # conversion from nil to integer`). Configure `EnforcedStyle: uppercase`
      # to require the opposite convention instead.
      #
      # @example EnforcedStyle: lowercase (default)
      #   # bad
      #   raise ArgumentError, "Block is required"
      #
      #   # good
      #   raise ArgumentError, "block is required"
      #
      # @example EnforcedStyle: uppercase
      #   # bad
      #   raise ArgumentError, "block is required"
      #
      #   # good
      #   raise ArgumentError, "Block is required"
      class Casing < Base
        include ConfigurableEnforcedStyle
        include MessageNode
        extend AutoCorrector

        MSG = 'Exception messages should start with a %<style>s letter.'

        def on_send(node)
          message_node = raise_message_node(node)
          return unless message_node

          first_segment = first_string_segment(message_node)
          return unless first_segment

          content = first_segment.value
          return if content.empty? || !offense?(content)

          register_offense(message_node, first_segment, content)
        end

        private

        def register_offense(message_node, segment, content)
          add_offense(message_node, message: format(MSG, style: style)) do |corrector|
            corrected = content.sub(/\A./, &correction_method)
            corrector.replace(segment.loc.expression, segment.source.sub(content, corrected))
          end
        end

        def offense?(content)
          first_char = content[0]
          first_char =~ (style == :lowercase ? /[A-Z]/ : /[a-z]/)
        end

        def correction_method
          style == :lowercase ? :downcase : :upcase
        end

        def first_string_segment(message_node)
          segment = message_node.str_type? ? message_node : message_node.child_nodes.first
          segment if segment&.str_type?
        end
      end
    end
  end
end
