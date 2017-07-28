require 'vmstat'

module AppPerfAgent
  module Plugin
    module System
      class Memory < AppPerfAgent::Plugin::Base
        def call
          memory = Vmstat.memory
          [
            [
              AppPerfAgent::Types::MEMORY,
              "system.memory.free_bytes",
              "Memory (Free)",
              memory.free_bytes
            ],
            [
              AppPerfAgent::Types::MEMORY,
              "system.memory.inactive_bytes",
              "Memory (Inactive)",
              memory.inactive_bytes
            ],
            [
              AppPerfAgent::Types::MEMORY,
              "system.memory.active_bytes",
              "Memory (Active)",
              memory.active_bytes
            ],
            [
              AppPerfAgent::Types::MEMORY,
              "system.memory.wired_bytes",
              "Memory (Wired)",
              memory.wired_bytes
            ],
            [
              AppPerfAgent::Types::MEMORY,
              "system.memory.total_bytes",
              "Memory (Total)",
              memory.total_bytes
            ]
          ]
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Memory monitoring."
