require 'travis/env_vars/collection'
require 'travis/env_vars/env_var'

module Travis
  class EnvVars
    class Hash
      attr_reader :hash

      def initialize(hash)
        @hash = hash
      end

      def parses?
        hash.keys.all? { |key| /^[A-Z_]+$/.match(key) }
      end

      def parse
        Collection.new.tap do |collection|
          hash.each { |key, value| collection << parse_pair(key, value) }
        end
      end

      private

      def parse_pair(key, value)
        key == :secure ? SecureEnvVar.new(value) : EnvVar.new(key, value)
      end
    end
  end
end
