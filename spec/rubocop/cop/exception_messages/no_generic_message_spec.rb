# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ExceptionMessages::NoGenericMessage, :config do
  let(:cop_config) do
    {
      'MinimumWords' => 1,
      'GenericMessages' => %w[bad error failed invalid]
    }
  end

  it 'does not require a minimum character count by default' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "x"
    RUBY
  end

  context 'with custom word limits' do
    let(:cop_config) do
      {
        'MinimumLength' => 1,
        'MinimumWords' => 3,
        'MaximumWords' => 4,
        'GenericMessages' => []
      }
    end

    it 'registers an offense for a message below the minimum word count' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "invalid input"
                             ^^^^^^^^^^^^^^^ Exception message should contain at least 3 words.
      RUBY
    end

    it 'registers an offense for a message above the maximum word count' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "the input value is invalid"
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Exception message should contain at most 4 words.
      RUBY
    end

    it 'does not register an offense for a message within the word limits' do
      expect_no_offenses(<<~RUBY)
        raise ArgumentError, "invalid input value"
      RUBY
    end
  end

  context 'with a custom minimum length' do
    let(:cop_config) do
      {
        'MinimumLength' => 2,
        'MinimumWords' => 1,
        'GenericMessages' => %w[bad error failed invalid]
      }
    end

    it 'registers an offense for a message shorter than the minimum length' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "x"
                             ^^^ Exception message should contain at least 2 characters.
      RUBY
    end
  end

  context 'with a custom maximum length' do
    let(:cop_config) do
      {
        'MinimumLength' => 2,
        'MaximumLength' => 10,
        'GenericMessages' => %w[bad error failed invalid]
      }
    end

    it 'registers an offense for a message longer than the maximum length' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "message is too long"
                             ^^^^^^^^^^^^^^^^^^^^^ Exception message should contain at most 10 characters.
      RUBY
    end

    it 'does not register an offense for a message meeting the maximum' do
      expect_no_offenses(<<~RUBY)
        raise ArgumentError, "1234567890"
      RUBY
    end
  end

  it 'registers an offense for a generic message with raise Class.new(message)' do
    expect_offense(<<~RUBY)
      raise ArgumentError.new("failed")
                              ^^^^^^^^ Exception message is too generic, add more context.
    RUBY
  end

  it 'registers an offense for a generic message with fail' do
    expect_offense(<<~RUBY)
      fail ArgumentError, "invalid"
                          ^^^^^^^^^ Exception message is too generic, add more context.
    RUBY
  end

  it 'registers an offense for a generic message with a string fail' do
    expect_offense(<<~RUBY)
      fail "invalid"
           ^^^^^^^^^ Exception message is too generic, add more context.
    RUBY
  end

  it 'registers an offense for a generic message with super' do
    expect_offense(<<~RUBY)
      super("invalid")
            ^^^^^^^^^ Exception message is too generic, add more context.
    RUBY
  end

  it 'does not register an offense for a contextual super message' do
    expect_no_offenses(<<~RUBY)
      super("invalid value")
    RUBY
  end

  it 'registers an offense for a generic message regardless of its case' do
    expect_offense(<<~RUBY)
      raise StandardError, "Error"
                           ^^^^^^^ Exception message is too generic, add more context.
    RUBY
  end

  it 'registers an offense for a generic message with surrounding whitespace' do
    expect_offense(<<~RUBY)
      raise RuntimeError, "  failed  "
                          ^^^^^^^^^^^^ Exception message is too generic, add more context.
    RUBY
  end

  it 'does not register an offense for a message with additional context' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "invalid type"
    RUBY
  end

  it 'does not register an offense for a message with multiple words' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "unsupported type"
    RUBY
  end

  it 'does not register an offense for an interpolated message' do
    expect_no_offenses(<<~'RUBY')
      raise ArgumentError, "#{context} is invalid"
    RUBY
  end

  it 'does not register an offense for a bare raise with no message' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError
    RUBY
  end

  it 'does not register an offense for a bare re-raise' do
    expect_no_offenses(<<~RUBY)
      raise
    RUBY
  end

  context 'with a custom GenericWords list' do
    let(:cop_config) do
      {
        'MinimumLength' => 2,
        'GenericMessages' => ['nope']
      }
    end

    it 'registers an offense for the configured word' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "nope"
                             ^^^^^^ Exception message is too generic, add more context.
      RUBY
    end

    it 'does not register an offense for a default word that is no longer configured' do
      expect_no_offenses(<<~RUBY)
        raise ArgumentError, "invalid type"
      RUBY
    end

    it 'does not register an offense for a message meeting the minimum' do
      expect_no_offenses(<<~RUBY)
        raise ArgumentError, "unsupported type"
      RUBY
    end
  end

  context 'with a custom minimum length' do
    let(:cop_config) do
      {
        'MinimumLength' => 3,
        'GenericMessages' => %w[bad error failed invalid]
      }
    end

    it 'registers an offense for a message below the configured minimum' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "ab"
                             ^^^^ Exception message should contain at least 3 characters.
      RUBY
    end

    it 'does not register an offense for a message meeting the configured minimum' do
      expect_no_offenses(<<~RUBY)
        raise ArgumentError, "unsupported argument type"
      RUBY
    end

    it 'still registers an offense for a listed generic word' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "invalid"
                             ^^^^^^^^^ Exception message is too generic, add more context.
      RUBY
    end

    context 'with custom generic messages' do
      let(:cop_config) do
        {
          'MinimumLength' => 1,
          'GenericMessages' => ['not found', '/^operation (failed|aborted)$/i']
        }
      end

      it 'registers an offense for a generic phrase' do
        expect_offense(<<~RUBY)
          raise ArgumentError, "Not Found"
                               ^^^^^^^^^^^ Exception message is too generic, add more context.
        RUBY
      end

      it 'registers an offense for a matching regular expression' do
        expect_offense(<<~RUBY)
          raise ArgumentError, "operation failed"
                               ^^^^^^^^^^^^^^^^^^ Exception message is too generic, add more context.
        RUBY
      end

      it 'does not register an offense when a regular expression does not match' do
        expect_no_offenses(<<~RUBY)
          raise ArgumentError, "operation succeeded"
        RUBY
      end
    end

    context 'with per-exception configuration' do
      let(:cop_config) do
        {
          'MinimumLength' => 2,
          'GenericMessages' => ['invalid'],
          'Exceptions' => {
            'ArgumentError' => {
              'MinimumLength' => 10,
              'MaximumLength' => 20,
              'GenericMessages' => ['bad argument']
            }
          }
        }
      end

      it 'uses the configured minimum for the exception' do
        expect_offense(<<~RUBY)
          raise ArgumentError, "too short"
                               ^^^^^^^^^^^ Exception message should contain at least 10 characters.
        RUBY
      end

      it 'uses the configured maximum for the exception' do
        expect_offense(<<~RUBY)
          raise ArgumentError, "this message is too long"
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^ Exception message should contain at most 20 characters.
        RUBY
      end

      it 'uses the configured generic messages for the exception' do
        expect_offense(<<~RUBY)
          raise ArgumentError, "bad argument"
                               ^^^^^^^^^^^^^^ Exception message is too generic, add more context.
        RUBY
      end

      it 'uses global configuration for other exceptions' do
        expect_offense(<<~RUBY)
          raise RuntimeError, "invalid"
                              ^^^^^^^^^ Exception message is too generic, add more context.
        RUBY
      end
    end
  end

  context 'with per-exception word limits' do
    let(:cop_config) do
      {
        'MinimumLength' => 1,
        'Exceptions' => {
          'ArgumentError' => {
            'MinimumWords' => 3,
            'MaximumWords' => 5
          }
        }
      }
    end

    it 'uses the configured minimum word count for the exception' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "one two"
                             ^^^^^^^^^ Exception message should contain at least 3 words.
      RUBY
    end

    it 'uses the configured maximum word count for the exception' do
      expect_offense(<<~RUBY)
        raise ArgumentError, "one two three four five six"
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Exception message should contain at most 5 words.
      RUBY
    end
  end
end
