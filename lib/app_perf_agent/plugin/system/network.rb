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
              ["system.network.in_bytes", inet.in_bytes, { "name" => inet.name.to_s }],
              ["system.network.out_bytes", inet.out_bytes, { "name" => inet.name.to_s }]
            ]
          }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Network monitoring."
