require "vmstat"
require_relative "../base"

module AppPerfAgent
  module Plugin
    module System
      class Load < AppPerfAgent::Plugin::Base
        def call
          loads = Vmstat.load_average
          [
            ["system.load.one_minute",     loads.one_minute],
            ["system.load.five_minute",    loads.five_minutes],
            ["system.load.fifteen_minute", loads.fifteen_minutes]
          ]
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Load monitoring."
