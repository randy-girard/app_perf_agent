require 'vmstat'
require_relative "../base"

module AppPerfAgent
  module Plugin
    module System
      class Memory < AppPerfAgent::Plugin::Base
        def call
          memory = Vmstat.memory
          [
            ["system.memory.stats",     memory.free_bytes, { "metric" => "free", "host" => AppPerfAgent.hostname }],
            ["system.memory.stats", memory.inactive_bytes, { "metric" => "inactive", "host" => AppPerfAgent.hostname }],
            ["system.memory.stats",   memory.active_bytes, { "metric" => "active", "host" => AppPerfAgent.hostname }],
            ["system.memory.stats",    memory.wired_bytes, { "metric" => "wired", "host" => AppPerfAgent.hostname }],
            #["system.memory.stats",    memory.total_bytes, { "metric" => "total", "host" => AppPerfAgent.hostname }]
          ]
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Memory monitoring."
