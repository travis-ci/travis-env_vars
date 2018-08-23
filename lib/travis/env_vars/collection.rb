require 'set'

module Travis
  class EnvVars
    class Collection < Set
      def to_pairs
        map(&:to_pair)
      end

      def to_h
        ::Hash[to_pairs]
      end

      def to_strings
        map(&:to_s)
      end

      def to_s(delimiter = ' ')
        to_strings.join(delimiter)
      end

      def deep_merge(other)
        other.union(self)
      end
    end
  end
end
