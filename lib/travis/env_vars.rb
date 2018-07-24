require 'travis/env_vars/string'
require 'travis/env_vars/version'

# TODO this doesn't work with secure env vars, yet

module Travis
  class EnvVars
    ArgumentError = Class.new(::ArgumentError)
    ParseError    = Class.new(ArgumentError)

    attr_reader :objs

    def initialize(*objs)
      @objs = objs.map { |obj| normalize(obj) }
    end

    def to_h(merge_mode = :merge)
      send(merge_mode)
    end

    def to_a(merge_mode = :merge)
      send(merge_mode).map { |pair| pair.join('=') }
    end

    private

      def normalize(obj)
        case obj
        when ::String
          String.new(obj).parse
        when Hash
          obj
        else
          raise ArgumentError, "unsupported type #{obj.class} (given: #{obj.inspect})"
        end
      end

      def replace
        # TODO
      end

      def merge
        objs.inject(&:merge)
      end

      def deep_merge
        # TODO
      end
  end
end
