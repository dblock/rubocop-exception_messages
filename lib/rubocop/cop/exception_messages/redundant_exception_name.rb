# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks that raised exception messages do not redundantly repeat the
      # exception class name, since Ruby already prints the class name
      # ahead of the message in a backtrace (`ArgumentError: block is
      # required`, not `ArgumentError: ArgumentError: block is required`).
      #
      # @example
      #   # bad
      #   raise ArgumentError, "ArgumentError: block is required"
      #
      #   # good
      #   raise ArgumentError, "block is required"
      class RedundantExceptionName < Base
        include MessageNode

        MSG = 'Exception messages should not repeat the exception class name.'

        def on_send(node)
          message_node = raise_message_node(node)
          return unless message_node

          first_segment = first_string_segment(message_node)
          return unless first_segment

          exception_name = exception_class_name(node)
          return unless exception_name

          return unless redundant?(first_segment.value, exception_name)

          add_offense(message_node)
        end

        private

        def redundant?(content, exception_name)
          content.match?(/\A#{Regexp.escape(exception_name)}\b/)
        end

        def exception_class_name(node)
          klass = raised_class_node(node)
          return unless klass&.const_type?

          klass.const_name&.split('::')&.last
        end

        def raised_class_node(node)
          first_arg = node.arguments.first
          return unless first_arg
          return first_arg.receiver if first_arg.send_type? && first_arg.method?(:new)

          first_arg
        end

        def first_string_segment(message_node)
          segment = message_node.str_type? ? message_node : message_node.child_nodes.first
          segment if segment&.str_type?
        end
      end
    end
  end
end
