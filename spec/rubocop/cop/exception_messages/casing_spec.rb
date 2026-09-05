# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ExceptionMessages::Casing, :config do
  it 'registers an offense for a capitalized message with raise Class, message' do
    expect_offense(<<~RUBY)
      raise ArgumentError, "Block is required"
                           ^^^^^^^^^^^^^^^^^^^ Exception messages should start with a lowercase letter.
    RUBY

    expect_correction(<<~RUBY)
      raise ArgumentError, "block is required"
    RUBY
  end

  it 'registers an offense for a capitalized message with raise Class.new(message)' do
    expect_offense(<<~RUBY)
      raise ArgumentError.new("Block is required")
                              ^^^^^^^^^^^^^^^^^^^ Exception messages should start with a lowercase letter.
    RUBY

    expect_correction(<<~RUBY)
      raise ArgumentError.new("block is required")
    RUBY
  end

  it 'does not register an offense for a lowercase message' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "block is required"
    RUBY
  end

  it 'does not register an offense for a lowercase message with raise Class.new(message)' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError.new("block is required")
    RUBY
  end

  it 'does not register an offense for a bare raise with no message' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError
    RUBY
  end

  it 'does not register an offense for an interpolated message starting lowercase' do
    expect_no_offenses(<<~'RUBY')
      raise ArgumentError, "unknown type: #{type}"
    RUBY
  end

  it 'registers an offense for an interpolated message starting uppercase' do
    expect_offense(<<~'RUBY')
      raise ArgumentError, "Unknown type: #{type}"
                           ^^^^^^^^^^^^^^^^^^^^^^^ Exception messages should start with a lowercase letter.
    RUBY

    expect_correction(<<~'RUBY')
      raise ArgumentError, "unknown type: #{type}"
    RUBY
  end
end
