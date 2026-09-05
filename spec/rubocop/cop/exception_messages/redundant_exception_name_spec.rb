# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ExceptionMessages::RedundantExceptionName, :config do
  it 'registers an offense for a message repeating the exception class name with raise Class, message' do
    expect_offense(<<~RUBY)
      raise ArgumentError, "ArgumentError: block is required"
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Exception messages should not repeat the exception class name.
    RUBY
  end

  it 'registers an offense for a message repeating the exception class name with raise Class.new(message)' do
    expect_offense(<<~RUBY)
      raise ArgumentError.new("ArgumentError block is required")
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Exception messages should not repeat the exception class name.
    RUBY
  end

  it 'registers an offense for a namespaced exception class' do
    expect_offense(<<~RUBY)
      raise Grape::Exceptions::InvalidVersionerOption, "InvalidVersionerOption: bad option"
                                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Exception messages should not repeat the exception class name.
    RUBY
  end

  it 'does not register an offense for a message that does not repeat the exception class name' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "block is required"
    RUBY
  end

  it 'does not register an offense when the exception class name appears mid-message' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "not a valid ArgumentError here"
    RUBY
  end

  it 'does not register an offense for a bare raise with no message' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError
    RUBY
  end

  it 'does not register an offense for an interpolated message' do
    expect_no_offenses(<<~'RUBY')
      raise ArgumentError, "#{ArgumentError} says no"
    RUBY
  end
end
