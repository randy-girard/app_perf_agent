require "vmstat"

module AppPerfAgent
  module Plugin
    module System
      class Load < AppPerfAgent::Plugin::Base
        def call
          loads = Vmstat.load_average
          [
            [
              AppPerfAgent::Types::LOAD,
              "system.load.one_minute",
              "Load - One Minute",
              loads.one_minute
            ],
            [
              AppPerfAgent::Types::LOAD,
              "system.load.five_minute",
              "Load - Five Minute",
              loads.five_minutes
            ],
            [
              AppPerfAgent::Types::LOAD,
              "system.load.fifteen_minute",
              "Load - Fifteen Minute",
              loads.fifteen_minutes
            ]
          ]
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Load monitoring."
