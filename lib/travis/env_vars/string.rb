require 'strscan'
require 'forwardable'

module Travis
  class EnvVars
    class String
      KEY   = /[^\s=]+/
      WORD  = /(\\.*|[^'"\s])+/
      QUOTE = /(['"`]{1})/
      SPACE = /\s+/
      EQUAL = /=/
      SUBSH = /\$\(.*?\)/

      extend Forwardable

      def_delegators :str, :check, :eos?, :peek, :pos, :scan, :skip, :string
      attr_reader :str

      def initialize(str)
        @str = StringScanner.new(str)
      end

      def to_h
        pairs.to_h
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
        # return unless peek(1) =~ QUOTE
        # scan(/#{$1}(\\#{$1}|[^#{$1}])*#{$1}/)
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
