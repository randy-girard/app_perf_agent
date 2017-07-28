module AppPerfAgent
  module Plugin
    class Base
      def self.descendants
        @descendants ||= ObjectSpace.each_object(Class).select { |klass| klass < self }
      end
      
      def call
        raise "Not Implemented"
      end
    end
  end
end
