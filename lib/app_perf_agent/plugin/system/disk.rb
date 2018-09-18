require "vmstat"
require_relative "../base"

module AppPerfAgent
  module Plugin
    module System
      class Disk < AppPerfAgent::Plugin::Base
        def call
          disks = Vmstat.snapshot.disks
          disks.flat_map {|disk|
            [
              ["system.disk.stats",       disk.used_bytes, { "metric" => "used",      "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount, "host" => AppPerfAgent.hostname }],
              ["system.disk.stats",       disk.free_bytes, { "metric" => "free",      "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount, "host" => AppPerfAgent.hostname }],
              #["system.disk.stats",  disk.available_bytes, { "metric" => "available", "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount, "host" => AppPerfAgent.hostname }],
              #["system.disk.stats",      disk.total_bytes, { "metric" => "total",     "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount, "host" => AppPerfAgent.hostname }]
            ]
          }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Disk monitoring."
