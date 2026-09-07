# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ExceptionMessages::RequireMessage, :config do
  let(:cop_config) { { 'Enabled' => true, 'AllowedExceptions' => [] } }

  it 'registers an offense for a bare raise with a class and no message' do
    expect_offense(<<~RUBY)
      raise ArgumentError
      ^^^^^^^^^^^^^^^^^^^ Provide a message when raising ArgumentError.
    RUBY
  end

  it 'registers an offense for raise Class.new with no message' do
    expect_offense(<<~RUBY)
      raise ArgumentError.new
      ^^^^^^^^^^^^^^^^^^^^^^^ Provide a message when raising ArgumentError.
    RUBY
  end

  it 'registers an offense for raise Class.new() with no message' do
    expect_offense(<<~RUBY)
      raise ArgumentError.new()
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Provide a message when raising ArgumentError.
    RUBY
  end

  it 'registers an offense for a namespaced exception class with no message' do
    expect_offense(<<~RUBY)
      raise Grape::Exceptions::InvalidVersionerOption
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Provide a message when raising Grape::Exceptions::InvalidVersionerOption.
    RUBY
  end

  it 'does not register an offense for raise Class, message' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError, "block is required"
    RUBY
  end

  it 'does not register an offense for raise Class.new(message)' do
    expect_no_offenses(<<~RUBY)
      raise ArgumentError.new("block is required")
    RUBY
  end

  it 'does not register an offense for a bare re-raise with no class' do
    expect_no_offenses(<<~RUBY)
      begin
        do_something
      rescue StandardError
        raise
      end
    RUBY
  end

  it 'does not register an offense for raising a plain string' do
    expect_no_offenses(<<~RUBY)
      raise "block is required"
    RUBY
  end

  it 'does not register an offense for raising a variable' do
    expect_no_offenses(<<~RUBY)
      raise error
    RUBY
  end

  context 'with the default AllowedExceptions' do
    let(:cop_config) { { 'Enabled' => true } }

    it 'does not register an offense for NotImplementedError with no message' do
      expect_no_offenses(<<~RUBY)
        raise NotImplementedError
      RUBY
    end

    it 'does not register an offense for NotImplementedError via Class.new' do
      expect_no_offenses(<<~RUBY)
        raise NotImplementedError.new
      RUBY
    end

    it 'still registers an offense for a different exception with no message' do
      expect_offense(<<~RUBY)
        raise ArgumentError
        ^^^^^^^^^^^^^^^^^^^ Provide a message when raising ArgumentError.
      RUBY
    end

    it 'matches an allowed exception by its short name when namespaced' do
      expect_no_offenses(<<~RUBY)
        raise Foo::NotImplementedError
      RUBY
    end
  end

  context 'when AllowedExceptions is overridden without repeating the default' do
    let(:cop_config) { { 'Enabled' => true, 'AllowedExceptions' => ['MyApp::PluginError'] } }

    it 'registers an offense for NotImplementedError since it is no longer allowed' do
      expect_offense(<<~RUBY)
        raise NotImplementedError
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Provide a message when raising NotImplementedError.
      RUBY
    end

    it 'does not register an offense for the newly allowed exception' do
      expect_no_offenses(<<~RUBY)
        raise MyApp::PluginError
      RUBY
    end
  end
end
