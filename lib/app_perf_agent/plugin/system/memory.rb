require 'vmstat'
require_relative "../base"

module AppPerfAgent
  module Plugin
    module System
      class Memory < AppPerfAgent::Plugin::Base
        def call
          memory = Vmstat.memory
          [
            ["system.memory.free_bytes",     memory.free_bytes],
            ["system.memory.inactive_bytes", memory.inactive_bytes],
            ["system.memory.active_bytes",   memory.active_bytes],
            ["system.memory.wired_bytes",    memory.wired_bytes],
            ["system.memory.total_bytes",    memory.total_bytes]
          ]
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Memory monitoring."
