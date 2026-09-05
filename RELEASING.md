Releasing rubocop-exception_messages
=====================================

There're no particular rules about when to release rubocop-exception_messages. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

### Release

Run tests, check that all tests succeed locally.

```
bundle install
bundle exec rake
```

Double-check that the [last build succeeded](https://github.com/dblock/rubocop-exception_messages/actions) in GitHub Actions.

Change "Next" in [CHANGELOG.md](CHANGELOG.md) to the new version.

```
### 0.1.0 (2026/1/1)
```

Remove the line with "* Your contribution here.", since there will be no more contributions to this release.

Bump the version in [lib/rubocop/exception_messages/version.rb](lib/rubocop/exception_messages/version.rb).

```ruby
module RuboCop
  module ExceptionMessages
    VERSION = '0.1.0'
  end
end
```

Commit your changes.

```
git add CHANGELOG.md lib/rubocop/exception_messages/version.rb
git commit -m "Preparing for release, 0.1.0."
git push origin master
```

Release.

```
$ bundle exec rake release

rubocop-exception_messages 0.1.0 built to pkg/rubocop-exception_messages-0.1.0.gem.
Tagged v0.1.0.
Pushed git commits and tags.
Pushed rubocop-exception_messages 0.1.0 to rubygems.org.
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
### 0.1.1 (Next)

#### Features

* Your contribution here.

#### Fixes

* Your contribution here.
```

Bump the version in [lib/rubocop/exception_messages/version.rb](lib/rubocop/exception_messages/version.rb).

```ruby
module RuboCop
  module ExceptionMessages
    VERSION = '0.1.1'
  end
end
```

Commit your changes.

```
git add CHANGELOG.md lib/rubocop/exception_messages/version.rb
git commit -m "Preparing for next development iteration, 0.1.1."
git push origin master
```
