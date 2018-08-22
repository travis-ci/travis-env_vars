require 'strscan'
require 'forwardable'
require 'travis/env_vars/collection'
require 'travis/env_vars/env_var'

module Travis
  class EnvVars
    class String
      KEY   = %r([^\s=]+)
      WORD  = %r((\\.*|[^'"\s])+)
      QUOTE = %r((['"`]{1}))
      SPACE = %r(\s+)
      EQUAL = %r(=)
      SUBSH = %r(\$\(.*?\))

      extend Forwardable

      def_delegators :str, :check, :eos?, :peek, :pos, :scan, :skip, :string, :reset
      attr_reader :str

      def initialize(str)
        @str = StringScanner.new(str.to_s.strip)
      end

      def parses?
        parse
        reset
        true
      rescue ParseError
        false
      end

      def parse
        collection = Collection.new
        collection << take
        collection << take while space
        collection.tap { err('end of string') unless eos? }
      end

      def take
        return unless key = self.key
        parts = [key, equal, value]
        EnvVar.new(parts.first, parts.last)
      end

      def key
        scan(KEY)
      end

      def equal
        scan(EQUAL) || err('=')
      end

      def value
        quoted || subshell || word
      end

      def word
        scan(WORD)
      end

      def subshell
        scan(SUBSH)
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
  end
end
