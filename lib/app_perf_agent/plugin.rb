module AppPerfAgent
  module Plugin
    class << self
      def load_plugins
        pattern = File.join(File.dirname(__FILE__), 'plugin', '**', '*.rb')

        Dir.glob(pattern) do |f|
          begin
            require f
          rescue => e
            AppPerfAgent.logger.info "Error loading plugin '#{f}' : #{e}"
            AppPerfAgent.logger.info "#{e.backtrace.first}"
          end
        end
      end

      def plugins
        @plugins ||= ::AppPerfAgent::Plugin::Base
          .descendants
          .map(&:new)
      end
    end
  end
end
