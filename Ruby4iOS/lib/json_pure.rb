if ENV['SIMPLECOV_COVERAGE'].to_i == 1
  require 'simplecov'
  SimpleCov.start do
    add_filter "/tests/"
  end
end
require 'json_common'
require 'json_pure_parser'
require 'json_pure_generator'

module JSON
  # This module holds all the modules/classes that implement JSON's
  # functionality in pure ruby.
  module Pure
    $DEBUG and warn "Using Pure library for JSON."
    JSON.parser = Parser
    JSON.generator = Generator
  end

  JSON_LOADED = true unless defined?(::JSON::JSON_LOADED)
end