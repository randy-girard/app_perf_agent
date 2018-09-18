require "vmstat"
require_relative "../base"

module AppPerfAgent
  module Plugin
    module System
      class Cpu < AppPerfAgent::Plugin::Base
        attr_accessor :last

        def initialize
          self.last = Vmstat.snapshot.cpus
          super
        end

        def call
          cpus = Vmstat.snapshot.cpus
          metrics = cpus.each_with_index.flat_map {|cpu, index|
            total = (cpu.idle + cpu.nice + cpu.system + cpu.user) - (last[index].idle + last[index].nice + last[index].system + last[index].user)
            [
              ["system.cpu.stats",   (cpu.idle - last[index].idle).to_f / total.to_f * 100.to_f,   { "metric" => "idle", "num" => cpu.num, "host" => AppPerfAgent.hostname }],
              ["system.cpu.stats",   (cpu.nice - last[index].nice).to_f / total.to_f * 100.to_f,   { "metric" => "nice", "num" => cpu.num, "host" => AppPerfAgent.hostname }],
              ["system.cpu.stats", (cpu.system - last[index].system).to_f / total.to_f * 100.to_f, { "metric" => "system", "num" => cpu.num, "host" => AppPerfAgent.hostname }],
              ["system.cpu.stats",   (cpu.user - last[index].user).to_f / total.to_f * 100.to_f,   { "metric" => "user", "num" => cpu.num, "host" => AppPerfAgent.hostname }]
            ]
          }
          self.last = cpus
          metrics
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading CPU monitoring."
