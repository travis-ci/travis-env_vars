require 'travis/env_vars/string'
require 'travis/env_vars/version'

module Travis
  class EnvVars
    ParseError = Class.new(ArgumentError)

    def initialize(*objs)
      @objs = merge(normalize(objs))
    end

    def to_a
      # return an array of strings with one key/value pair each
    end

    def to_h
      # return a hash
    end

    private

      def normalize(objs)
        # parse strings into hashes
      end

      def merge(objs)
        # merge these hashes
      end
  end
end
