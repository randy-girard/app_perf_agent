require "vmstat"
require_relative "../base"

module AppPerfAgent
  module Plugin
    module System
      class Load < AppPerfAgent::Plugin::Base
        def call
          loads = Vmstat.load_average
          [
            ["system.load.stats",     loads.one_minute,  { "metric" => "one_minute", "host" => AppPerfAgent.hostname }],
            ["system.load.stats",    loads.five_minutes, { "metric" => "five_minute", "host" => AppPerfAgent.hostname }],
            ["system.load.stats", loads.fifteen_minutes, { "metric" => "fifteen_minute", "host" => AppPerfAgent.hostname }]
          ]
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Load monitoring."
