# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks that a raised exception is given a message, since a bare
      # `raise SomeError` produces a backtrace with nothing but the class
      # name to go on. Opt-in, since not every project wants to require a
      # message for every exception.
      #
      # `AllowedExceptions` defaults to `NotImplementedError`, since it's
      # conventionally raised bare (e.g. for an abstract method, or a
      # feature unsupported on the current platform). This default is
      # replaced, not merged, if you configure `AllowedExceptions`
      # yourself, so repeat `NotImplementedError` in the list if you still
      # want it exempted.
      #
      # @example
      #   # bad
      #   raise ArgumentError
      #   raise ArgumentError.new
      #
      #   # good
      #   raise ArgumentError, "block is required"
      #   raise ArgumentError.new("block is required")
      #
      #   # good (bare re-raise)
      #   raise
      #
      #   # good (default AllowedExceptions)
      #   raise NotImplementedError
      #
      # @example AllowedExceptions: ['NotImplementedError', 'MyApp::PluginError']
      #   # good
      #   raise NotImplementedError
      #   raise MyApp::PluginError
      class RequireMessage < Base
        MSG = 'Provide a message when raising %<exception_name>s.'

        def on_send(node)
          return unless node.method?(:raise)

          exception_node = raised_class_node(node)
          return unless exception_node&.const_type?
          return if message_given?(node)

          exception_name = exception_node.const_name
          return if allowed?(exception_name)

          add_offense(node, message: format(MSG, exception_name: exception_name))
        end

        private

        def raised_class_node(node)
          first_arg = node.arguments.first
          return unless first_arg

          return first_arg.receiver if first_arg.send_type? && first_arg.method?(:new)

          first_arg
        end

        def message_given?(node)
          first_arg = node.arguments.first

          if first_arg.send_type? && first_arg.method?(:new)
            !first_arg.arguments.empty?
          else
            node.arguments.size > 1
          end
        end

        def allowed?(exception_name)
          allowed_exceptions.include?(exception_name) || allowed_exceptions.include?(exception_name&.split('::')&.last)
        end

        def allowed_exceptions
          cop_config['AllowedExceptions'] || []
        end
      end
    end
  end
end
