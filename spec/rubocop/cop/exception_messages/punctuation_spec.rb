# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ExceptionMessages::Punctuation, :config do
  it 'registers an offense for a message ending with a period with raise Class, message' do
    expect_offense(<<~RUBY)
      raise ArgumentError, "block is required."
                           ^^^^^^^^^^^^^^^^^^^^ Exception messages should not end with a period.
    RUBY

    expect_correction(<<~RUBY)
      raise ArgumentError, "block is required"
    RUBY
  end

  it 'registers an offense for a message ending with a period with raise Class.new(message)' do
    expect_offense(<<~RUBY)
      raise ArgumentError.new("block is required.")
                              ^^^^^^^^^^^^^^^^^^^^ Exception messages should not end with a period.
    RUBY

    expect_correction(<<~RUBY)
      raise ArgumentError.new("block is required")
    RUBY
  end

  it 'does not register an offense for a message without trailing punctuation' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "block is required"
    RUBY
  end

  it 'does not register an offense for a bare raise with no message' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError
    RUBY
  end

  it 'does not register an offense for an ellipsis' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "still processing.."
    RUBY
  end

  it 'registers an offense for an interpolated message ending with a period' do
    expect_offense(<<~'RUBY')
      raise ArgumentError, "unknown type: #{type}."
                           ^^^^^^^^^^^^^^^^^^^^^^^^ Exception messages should not end with a period.
    RUBY

    expect_correction(<<~'RUBY')
      raise ArgumentError, "unknown type: #{type}"
    RUBY
  end
end
