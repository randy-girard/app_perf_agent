require "vmstat"
require_relative "base"

module AppPerfAgent
  module Plugin
    module System
      class Cpu < AppPerfAgent::Plugin::Base
        def call
          cpus = Vmstat.snapshot.cpus
          cpus.flat_map {|cpu|
            [
              [
                AppPerfAgent::Types::CPU,
                "system.cpu.idle",
                "CPU ##{cpu.num} (Idle)",
                cpu.idle
              ],
              [
                AppPerfAgent::Types::CPU,
                "system.cpu.nice",
                "CPU ##{cpu.num} (Nice)",
                cpu.nice
              ],
              [
                AppPerfAgent::Types::CPU,
                "system.cpu.system",
                "CPU ##{cpu.num} (System)",
                cpu.system
              ],
              [
                AppPerfAgent::Types::CPU,
                "system.cpu.user",
                "CPU ##{cpu.num} (User)",
                cpu.user
              ]
            ]
          }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading CPU monitoring."
