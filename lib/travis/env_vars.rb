require "travis/env_vars/version"

require 'forwardable'
require 'set'
require 'strscan'

module Travis
  module EnvVars
    def self.parse(obj)
      # TODO
    end

    ParseError = Class.new(ArgumentError)

    module Parser
      class String
	KEY   = %r{[^\s=]+}
	WORD  = %r{(\\["']|[^'"\s])+}
	QUOTE = %r{(['"]{1})}
	SPACE = %r{\s+}
	EQUAL = %r{=}

	extend Forwardable

	def_delegators :str, :eos?, :check, :peek, :pos, :scan, :skip, :string

	attr_reader :str

	def initialize(str)
	  @str = StringScanner.new(str)
	end

	def parse
	  join(pairs).tap { err('end of string') unless eos? }
	end

	def join(pairs)
	  pairs.map { |pair| pair.join('=') }
	end

	def pairs
	  pairs = [pair]
	  pairs += self.pairs while space
	  pairs
	end

	def pair
	  return unless key = self.key
	  parts = [key, equal, value]
	  [parts.first, parts.last]
	end

	def key
	  scan(KEY)
	end

	def equal
	  scan(EQUAL) || err('=')
	end

	def value
	  quoted || word
	end

	def word
	  scan(WORD)
	end

	def quoted
	  return unless peek(1) =~ QUOTE
	  err($1) if check(/#{$1}\\#{$1}($|\s)/)
	  scan(/#{$1}(\\#{$1}|[^#{$1}])*#{$1}/)
	end

	def space
	  scan(SPACE)
	end

	def err(char)
	  raise ParseError, "expected #{char} at position #{pos} in: #{string.inspect}"
	end
      end

      class Hash
	# TODO
      end
    end

    class EnvVar
      # TODO
    end
  end
end
