# frozen_string_literal: true

module RuboCop
  module Cop
    module ExceptionMessages
      # Checks that interpolated values in raised exception messages are
      # consistently quoted, making it easier to spot where a dynamic value
      # begins and ends in a rendered message.
      #
      # @example EnforcedStyle: backticks (default)
      #   # bad
      #   raise ArgumentError, "unknown type: #{type}"
      #
      #   # good
      #   raise ArgumentError, "unknown type: `#{type}`"
      #
      # @example EnforcedStyle: custom (with Prefix: '?', Suffix: '')
      #   # bad
      #   raise ArgumentError, "unknown type: #{type}"
      #
      #   # good
      #   raise ArgumentError, "unknown type: ?#{type}"
      class QuoteStyle < Base
        include ConfigurableEnforcedStyle
        include MessageNode
        extend AutoCorrector

        MSG = 'Interpolated values in exception messages should be wrapped in %<style>s.'

        QUOTES = {
          backticks: ['`', '`'],
          single_quotes: ["'", "'"],
          double_quotes: ['"', '"'],
          square_brackets: ['[', ']'],
          parentheses: ['(', ')'],
          curly_braces: ['{', '}']
        }.freeze

        def on_send(node)
          message_node = raise_message_node(node)
          return unless message_node&.dstr_type?

          message_node.child_nodes.each do |segment|
            next unless segment.begin_type?

            check_interpolation(message_node, segment)
          end
        end

        private

        def check_interpolation(message_node, segment)
          open_quote, close_quote = quotes_for_style
          return if quoted?(segment, open_quote, close_quote)

          add_offense(segment, message: format(MSG, style: style_description)) do |corrector|
            open_quote, close_quote = escape_for_literal(message_node, open_quote, close_quote)
            corrector.insert_before(segment.loc.expression, open_quote)
            corrector.insert_after(segment.loc.expression, close_quote) unless close_quote.empty?
          end
        end

        def quotes_for_style
          return QUOTES.fetch(style) unless style == :custom

          [cop_config['Prefix'] || '', cop_config['Suffix'] || '']
        end

        def style_description
          return "`#{cop_config['Prefix']}` / `#{cop_config['Suffix']}`" if style == :custom

          style.to_s.tr('_', ' ')
        end

        def escape_for_literal(message_node, open_quote, close_quote)
          return [open_quote, close_quote] unless message_node.loc.respond_to?(:begin) && message_node.loc.begin

          outer_quote = message_node.loc.begin.source
          return [open_quote, close_quote] unless outer_quote == open_quote || outer_quote == close_quote

          [open_quote == outer_quote ? "\\#{open_quote}" : open_quote,
           close_quote == outer_quote ? "\\#{close_quote}" : close_quote]
        end

        def quoted?(segment, open_quote, close_quote)
          preceding = segment.left_sibling
          following = segment.right_sibling

          preceding_ok = open_quote.empty? ||
                         (preceding.is_a?(RuboCop::AST::StrNode) && preceding.value.end_with?(open_quote))
          following_ok = close_quote.empty? ||
                         (following.is_a?(RuboCop::AST::StrNode) && following.value.start_with?(close_quote))

          preceding_ok && following_ok
        end
      end
    end
  end
end
