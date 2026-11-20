# frozen_string_literal: true

# UDON spec repository - uses the udon gem for parsing
#
# This file provides a thin wrapper for use in benchmarking and testing.
# For production use, require the 'udon' gem directly.
#
# Usage:
#   require_relative 'lib/udon'
#   events = Udon.parse("|div Hello")

begin
  require 'udon'
rescue LoadError => e
  # For development, try to load from udon-ruby repo
  udon_ruby_path = File.expand_path('../../udon-ruby/lib', __dir__)
  if File.exist?(udon_ruby_path)
    $LOAD_PATH.unshift(udon_ruby_path)
    retry
  else
    raise LoadError, <<~MSG
      Could not load udon gem.

      Either:
        1. Install: gem install udon
        2. Or ensure ~/src/udon-ruby exists and run:
           cd ~/src/udon-ruby && bundle exec rake compile

      Original error: #{e.message}
    MSG
  end
end

# Re-export for convenience
module UdonSpec
  def self.parse(input)
    ::Udon.parse(input)
  end

  def self.version
    ::Udon::VERSION
  end
end
