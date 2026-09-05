# frozen_string_literal: true

require_relative 'lib/rubocop/exception_messages/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-exception_messages'
  spec.version = RuboCop::ExceptionMessages::VERSION
  spec.authors = ['Daniel (dB.) Doubrovkine']
  spec.email = ['dblock@dblock.org']

  spec.summary = 'RuboCop cops for standardizing the style of raised exception messages.'
  spec.description = 'RuboCop cops that check raised exception messages start with a lowercase letter ' \
                      "and do not end with a period, consistent with Ruby's own core and standard " \
                      'library exceptions.'
  spec.homepage = 'https://github.com/dblock/rubocop-exception_messages'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/dblock/rubocop-exception_messages'
  spec.metadata['changelog_uri'] = 'https://github.com/dblock/rubocop-exception_messages/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['default_lint_roller_plugin'] = 'RuboCop::ExceptionMessages::Plugin'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'lint_roller', '~> 1.1'
  spec.add_dependency 'rubocop', '~> 1.72'
end
