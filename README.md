# rubocop-exception_messages

[![Ruby](https://github.com/dblock/rubocop-exception_messages/actions/workflows/test.yml/badge.svg)](https://github.com/dblock/rubocop-exception_messages/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/dblock/rubocop-exception_messages/badge.svg?branch=master)](https://coveralls.io/github/dblock/rubocop-exception_messages?branch=master)

RuboCop cops that standardize the style of raised exception messages, consistent with Ruby's own core and standard library exceptions (e.g. `TypeError: no implicit conversion from nil to integer`, `ArgumentError: wrong number of arguments`).

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

### ExceptionMessages/Casing

Checks the capitalization of raised exception messages. Defaults to `EnforcedStyle: lowercase`.

```ruby
# bad
raise ArgumentError, "Block is required"
raise ArgumentError.new("Block is required")

# good
raise ArgumentError, "block is required"
raise ArgumentError.new("block is required")
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
raise ArgumentError.new("block is required.")

# good
raise ArgumentError, "block is required"
raise ArgumentError.new("block is required")
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

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Copyright and License

MIT License, see [LICENSE](LICENSE.txt) for details.
