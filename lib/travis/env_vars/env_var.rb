module Travis
  class EnvVars
    class EnvVar
      attr_reader :key, :value

      def initialize(key, value)
	@key, @value = key, value
      end

      def eql?(other)
	hash === other.hash
      end

      def hash
	key.to_s.to_i(32)
      end

      def to_pair
	[key, value]
      end

      def to_s
	"#{key}=#{value}"
      end

      def inspect
	"<%s %s>" % [self.class.name, to_s]
      end
    end
  end
end
