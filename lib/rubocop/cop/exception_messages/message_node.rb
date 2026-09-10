# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Shared helpers for locating the string literal passed to an exception
      # raising method.
      module MessageNode
        private

        def raise_message_node(node)
          return unless node.method?(:raise) || node.method?(:fail) || node.method?(:super)

          message_arg = extract_message_arg(node)
          return unless message_arg
          return unless message_arg.str_type? || message_arg.dstr_type?

          message_arg
        end

        def extract_message_arg(node)
          return if node.arguments.empty?
          return node.arguments.first if node.super_type?
          return single_message_arg(node) if node.arguments.one?

          first_arg = node.arguments.first
          return first_arg.arguments.first if exception_constructor?(first_arg)

          node.arguments[1]
        end

        def single_message_arg(node)
          arg = node.arguments.first
          return arg if arg.str_type? || arg.dstr_type?

          arg.arguments.first if exception_constructor?(arg)
        end

        def exception_constructor?(node)
          node.send_type? && node.method?(:new)
        end
      end
    end
  end
end
