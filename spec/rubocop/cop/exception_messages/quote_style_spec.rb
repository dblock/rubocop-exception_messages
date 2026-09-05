# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ExceptionMessages::QuoteStyle, :config do
  let(:cop_config) { { 'Enabled' => true } }

  context 'with EnforcedStyle: backticks (default)' do
    it 'registers an offense for an unquoted interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in backticks.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: `#{type}`"
      RUBY
    end

    it 'does not register an offense for a backtick-quoted interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: `#{type}`"
      RUBY
    end

    it 'does not register an offense for a message without interpolation' do
      expect_no_offenses(<<~RUBY)
        raise ArgumentError, "block is required"
      RUBY
    end

    it 'does not register an offense for a bare raise with no message' do
      expect_no_offenses(<<~RUBY)
        raise ArgumentError
      RUBY
    end

    it 'registers an offense for a %() literal message' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, %(unknown type: #{type})
                                             ^^^^^^^ Interpolated values in exception messages should be wrapped in backticks.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, %(unknown type: `#{type}`)
      RUBY
    end

    it 'registers an offense for a heredoc message' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, <<~MSG
          unknown type: #{type}
                        ^^^^^^^ Interpolated values in exception messages should be wrapped in backticks.
        MSG
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, <<~MSG
          unknown type: `#{type}`
        MSG
      RUBY
    end
  end

  context 'with EnforcedStyle: single_quotes' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'single_quotes' } }

    it 'registers an offense for an unquoted interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in single quotes.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: '#{type}'"
      RUBY
    end

    it 'does not register an offense for a single-quote-quoted interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: '#{type}'"
      RUBY
    end
  end

  context 'with EnforcedStyle: double_quotes' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'double_quotes' } }

    it 'registers an offense for an unquoted interpolated value and escapes the outer double quotes' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in double quotes.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: \"#{type}\""
      RUBY
    end

    it 'does not register an offense for a double-quote-quoted interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: \"#{type}\""
      RUBY
    end

    it 'does not escape double quotes when correcting a heredoc message' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, <<~MSG
          unknown type: #{type}
                        ^^^^^^^ Interpolated values in exception messages should be wrapped in double quotes.
        MSG
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, <<~MSG
          unknown type: "#{type}"
        MSG
      RUBY
    end
  end

  context 'with EnforcedStyle: square_brackets' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'square_brackets' } }

    it 'registers an offense for an unquoted interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in square brackets.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: [#{type}]"
      RUBY
    end

    it 'does not register an offense for a square-bracket-quoted interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: [#{type}]"
      RUBY
    end
  end

  context 'with EnforcedStyle: parentheses' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'parentheses' } }

    it 'registers an offense for an unquoted interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in parentheses.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: (#{type})"
      RUBY
    end

    it 'does not register an offense for a parentheses-quoted interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: (#{type})"
      RUBY
    end
  end

  context 'with EnforcedStyle: curly_braces' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'curly_braces' } }

    it 'registers an offense for an unquoted interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in curly braces.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: {#{type}}"
      RUBY
    end

    it 'does not register an offense for a curly-brace-quoted interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: {#{type}}"
      RUBY
    end
  end

  context 'with EnforcedStyle: custom (prefix and suffix)' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'custom', 'Prefix' => '/', 'Suffix' => '/' } }

    it 'registers an offense for an unmarked interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in `/` / `/`.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: /#{type}/"
      RUBY
    end

    it 'does not register an offense for an already-marked interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: /#{type}/"
      RUBY
    end
  end

  context 'with EnforcedStyle: custom (prefix only, no suffix)' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'custom', 'Prefix' => '?', 'Suffix' => '' } }

    it 'registers an offense for an unmarked interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in `?` / ``.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: ?#{type}"
      RUBY
    end

    it 'does not register an offense for an already prefixed interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: ?#{type}"
      RUBY
    end
  end

  context 'with EnforcedStyle: custom (no prefix or suffix configured)' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'custom' } }

    it 'does not register an offense since there is nothing to enforce' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
      RUBY
    end
  end

  context 'with EnforcedStyle: custom (multi-character prefix and suffix)' do
    let(:cop_config) { { 'Enabled' => true, 'EnforcedStyle' => 'custom', 'Prefix' => '<<', 'Suffix' => '>>' } }

    it 'registers an offense for an unmarked interpolated value' do
      expect_offense(<<~'RUBY')
        raise ArgumentError, "unknown type: #{type}"
                                            ^^^^^^^ Interpolated values in exception messages should be wrapped in `<<` / `>>`.
      RUBY

      expect_correction(<<~'RUBY')
        raise ArgumentError, "unknown type: <<#{type}>>"
      RUBY
    end

    it 'does not register an offense for an already-marked interpolated value' do
      expect_no_offenses(<<~'RUBY')
        raise ArgumentError, "unknown type: <<#{type}>>"
      RUBY
    end
  end
end
