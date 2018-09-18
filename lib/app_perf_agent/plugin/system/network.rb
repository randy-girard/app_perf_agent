require "vmstat"
require_relative "../base"

module AppPerfAgent
  module Plugin
    module System
      class Network < AppPerfAgent::Plugin::Base
        def call
          inets = Vmstat.ethernet_devices
          inets.flat_map {|inet|
            [
              ["system.network.stats", inet.in_bytes, { "metric" => "in_bytes", "name" => inet.name.to_s, "host" => AppPerfAgent.hostname }],
              ["system.network.stats", inet.out_bytes, { "metric" => "out_bytes", "name" => inet.name.to_s, "host" => AppPerfAgent.hostname }]
            ]
          }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Network monitoring."
