require "vmstat"
require_relative "base"

module AppPerfAgent
  module Plugin
    module System
      class Network < AppPerfAgent::Plugin::Base
        def call
          inets = Vmstat.ethernet_devices
          inets.flat_map {|inet|
            [
              [
                AppPerfAgent::Types::NETWORK,
                "system.network.in_bytes",
                inet.name.to_s,
                inet.in_bytes
              ],
              [
                AppPerfAgent::Types::NETWORK,
                "system.network.out_bytes",
                inet.name.to_s,
                inet.out_bytes
              ]
            ]
          }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Network monitoring."
