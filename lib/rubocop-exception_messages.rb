# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/exception_messages/version'
require_relative 'rubocop/cop/exception_messages_cops'
require_relative 'rubocop/exception_messages'
require_relative 'rubocop/exception_messages/inject'

RuboCop::ExceptionMessages::Inject.defaults!
