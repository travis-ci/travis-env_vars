require 'travis/env_vars/hash'
require 'travis/env_vars/string'
require 'travis/env_vars/version'

# TODO this doesn't work with secure env vars, yet

module Travis
  class EnvVars
    ArgumentError = Class.new(::ArgumentError)
    ParseError    = Class.new(ArgumentError)

    attr_reader :obj

    def initialize(obj)
      @obj = obj
    end

    def parse
      case obj
      when ::String
        String.new(obj).parse
      when ::Hash
        Hash.new(obj).parse
      else
        raise ArgumentError, "unsupported type #{obj.class} (given: #{obj.inspect})"
      end
    end
    alias :to_collection :parse

    %i(to_pairs to_h to_strings to_s).each do |method|
      define_method(method) do
        to_collection.send(method)
      end
    end

    alias :to_a :to_strings
  end
end
