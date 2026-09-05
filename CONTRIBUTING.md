Contributing to rubocop-exception_messages
===========================================

This gem follows the same contribution flow as most Ruby open-source projects.

#### Fork the Project

Fork the [project on Github](https://github.com/dblock/rubocop-exception_messages) and check out your copy.

```
git clone https://github.com/contributor/rubocop-exception_messages.git
cd rubocop-exception_messages
git remote add upstream https://github.com/dblock/rubocop-exception_messages.git
```

#### Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout main
git pull upstream main
git checkout -b my-feature-branch
```

#### Bundle Install and Test

Ensure that you can build the project and run tests.

```
bundle install
bundle exec rake
```

#### Write Tests

Add specs for new or changed cop behavior under [spec/rubocop/cop/exception_messages](spec/rubocop/cop/exception_messages), using RuboCop's `expect_offense`/`expect_correction` helpers.

#### Write Code

Implement your feature or bug fix. Ruby style is enforced with RuboCop itself: run `bundle exec rubocop` and fix any style issues highlighted.

Make sure that `bundle exec rake` completes without errors.

#### Update Changelog

Add a line to [CHANGELOG.md](CHANGELOG.md) under *Next Release*, including your name and a link to your Github account.

#### Commit Changes

Make sure git knows your name and email address:

```
git config --global user.name "Your Name"
git config --global user.email "contributor@example.com"
```

Writing good commit messages is important. A commit message should describe what changed, why, and reference issues fixed (if any).

#### Push

```
git push origin my-feature-branch
```

#### Make a Pull Request

Go to https://github.com/contributor/rubocop-exception_messages and select your feature branch, then click the pull request button and fill out the form.

#### Be Patient

It may take time for a maintainer to respond. Please be patient and allow for time to review contributions.

#### Thank You

Please do know that we really appreciate and value your time and work. We love you, really.
