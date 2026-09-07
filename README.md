# rubocop-exception_messages

[![Ruby](https://github.com/dblock/rubocop-exception_messages/actions/workflows/test.yml/badge.svg)](https://github.com/dblock/rubocop-exception_messages/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/dblock/rubocop-exception_messages/badge.svg?branch=master)](https://coveralls.io/github/dblock/rubocop-exception_messages?branch=master)

RuboCop cops that standardize the style of raised exception messages, consistent with Ruby's own core and standard library exceptions (e.g. `TypeError: no implicit conversion from nil to integer`, `ArgumentError: wrong number of arguments`).

## Table of Contents

- [Rationale](#rationale)
- [Installation](#installation)
- [Cops](#cops)
  - [ExceptionMessages/Casing](#exceptionmessagescasing)
  - [ExceptionMessages/Punctuation](#exceptionmessagespunctuation)
  - [ExceptionMessages/RedundantExceptionName](#exceptionmessagesredundantexceptionname)
  - [ExceptionMessages/QuoteStyle](#exceptionmessagesquotestyle)
  - [ExceptionMessages/RequireMessage](#exceptionmessagesrequiremessage)
- [Contributing](#contributing)
- [Copyright and License](#copyright-and-license)

## Rationale

Ruby's built-in exceptions never capitalize or punctuate their messages. This reads naturally when Ruby prints the exception class name, a colon, and the message together in a backtrace (`ArgumentError: block is required`, not `ArgumentError: Block is required.`). These cops help keep custom `raise` messages consistent with that convention.

## Installation

Add to your `Gemfile`:

```ruby
group :development do
  gem "rubocop-exception_messages", require: false
end
```

Then require it in your `.rubocop.yml`:

```yaml
plugins:
  - rubocop-exception_messages
```

## Cops

All cops recognize both `raise Class, "message"` and `raise Class.new("message")` forms. Examples below use the `raise Class, "message"` form for brevity, except for `ExceptionMessages/RequireMessage`, where the choice between the two forms matters to the check itself.

### ExceptionMessages/Casing

Checks the capitalization of raised exception messages. Defaults to `EnforcedStyle: lowercase`.

```ruby
# bad
raise ArgumentError, "Block is required"

# good
raise ArgumentError, "block is required"
```

Configure `EnforcedStyle: uppercase` to require the opposite convention instead.

```yaml
ExceptionMessages/Casing:
  EnforcedStyle: uppercase
```

```ruby
# bad
raise ArgumentError, "block is required"

# good
raise ArgumentError, "Block is required"
```

### ExceptionMessages/Punctuation

Checks the trailing punctuation of raised exception messages. Defaults to `EnforcedStyle: no_period`. A literal ellipsis (`"..."`) is never considered an offense.

```ruby
# bad
raise ArgumentError, "block is required."

# good
raise ArgumentError, "block is required"
```

Configure `EnforcedStyle: period` to require a trailing period instead.

```yaml
ExceptionMessages/Punctuation:
  EnforcedStyle: period
```

```ruby
# bad
raise ArgumentError, "block is required"

# good
raise ArgumentError, "block is required."
```

Both cops support autocorrection (`rubocop -A`).

### ExceptionMessages/RedundantExceptionName

Checks that raised exception messages do not redundantly repeat the exception class name, since Ruby already prints the class name ahead of the message in a backtrace.

```ruby
# bad
raise ArgumentError, "ArgumentError: block is required"

# good
raise ArgumentError, "block is required"
```

### ExceptionMessages/QuoteStyle

Checks that interpolated values in raised exception messages are consistently quoted, making it easier to spot where a dynamic value begins and ends in a rendered message. Defaults to `EnforcedStyle: backticks`.

```ruby
# bad
raise ArgumentError, "unknown type: #{type}"

# good
raise ArgumentError, "unknown type: `#{type}`"
```

Configure `EnforcedStyle: single_quotes`, `double_quotes`, `square_brackets`, `parentheses`, or `curly_braces` to require a different wrapping instead.

```yaml
ExceptionMessages/QuoteStyle:
  Enabled: true
  EnforcedStyle: single_quotes
```

```ruby
# good
raise ArgumentError, "unknown type: '#{type}'"
```

Configure `EnforcedStyle: custom` with `Prefix`/`Suffix` for anything else, including a single-sided marker with no closing character.

```yaml
ExceptionMessages/QuoteStyle:
  Enabled: true
  EnforcedStyle: custom
  Prefix: '?'
```

```ruby
# good
raise ArgumentError, "unknown type: ?#{type}"
```

`Prefix`/`Suffix` aren't limited to a single character.

```yaml
ExceptionMessages/QuoteStyle:
  Enabled: true
  EnforcedStyle: custom
  Prefix: '--'
```

```ruby
# good
raise ArgumentError, "unknown type: --#{type}"
```

Configure `EnforcedStyle: none` to require interpolated values not be wrapped at all, and flag existing wrapping instead.

```yaml
ExceptionMessages/QuoteStyle:
  Enabled: true
  EnforcedStyle: none
```

```ruby
# bad
raise ArgumentError, "unknown type: `#{type}`"

# good
raise ArgumentError, "unknown type: #{type}"
```

### ExceptionMessages/RequireMessage

Checks that a raised exception is given a message, since a bare `raise SomeError` produces a backtrace with nothing but the class name to go on.

```ruby
# bad
raise ArgumentError
raise ArgumentError.new

# good
raise ArgumentError, "block is required"

# good (bare re-raise)
raise
```

`AllowedExceptions` exempts exception classes that don't need a message, and defaults to `NotImplementedError`, since it's conventionally raised bare (e.g. for an abstract method, or a feature unsupported on the current platform).

```ruby
# good, by default
raise NotImplementedError
```

RuboCop configuration doesn't merge arrays, it replaces them, so if you configure your own `AllowedExceptions`, repeat `NotImplementedError` in the list if you still want it exempted.

```yaml
ExceptionMessages/RequireMessage:
  Enabled: true
  AllowedExceptions:
    - NotImplementedError
    - MyApp::PluginError
```

```ruby
# good
raise NotImplementedError
raise MyApp::PluginError
```


## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Copyright and License

MIT License, see [LICENSE](LICENSE.txt) for details.
