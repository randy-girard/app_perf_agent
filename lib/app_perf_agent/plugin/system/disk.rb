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
              ["system.disk.used_bytes",       disk.used_bytes,      { "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount }],
              ["system.disk.free_bytes",       disk.free_bytes,      { "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount }],
              ["system.disk.available_bytes",  disk.available_bytes, { "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount }],
              ["system.disk.total_bytes",      disk.total_bytes,     { "origin" => disk.origin, "type" => disk.type, "mount" => disk.mount }]
            ]
          }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Disk monitoring."
