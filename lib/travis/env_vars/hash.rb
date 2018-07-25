require 'travis/env_vars/collection'
require 'travis/env_vars/env_var'

module Travis
  class EnvVars
    class Hash
      attr_reader :hash

      def initialize(hash)
        @hash = hash
      end

      def parse
        Collection.new.tap do |collection|
          hash.each { |key, value| collection << EnvVar.new(key, value) }
        end
      end
    end
  end
end
