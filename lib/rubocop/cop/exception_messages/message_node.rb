# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Shared helpers for locating the string literal passed to `raise`.
      module MessageNode
        private

        def raise_message_node(node)
          return unless node.method?(:raise)

          message_arg = extract_message_arg(node.arguments)
          return unless message_arg
          return unless message_arg.str_type? || message_arg.dstr_type?

          message_arg
        end

        def extract_message_arg(args)
          return if args.empty?

          first_arg = args.first
          return first_arg.arguments.first if first_arg.send_type? && first_arg.method?(:new)

          args[1]
        end
      end
    end
  end
end
