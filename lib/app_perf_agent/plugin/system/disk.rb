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
              [
                AppPerfAgent::Types::DISK,
                "system.disk.used_bytes",
                "#{disk.origin} - #{disk.type} (#{disk.mount})",
                disk.used_bytes
              ],
              [
                AppPerfAgent::Types::DISK,
                "system.disk.free_bytes",
                "#{disk.origin} - #{disk.type} (#{disk.mount})",
                disk.free_bytes
              ],
              [
                AppPerfAgent::Types::DISK,
                "system.disk.available_bytes",
                "#{disk.origin} - #{disk.type} (#{disk.mount})",
                disk.available_bytes
              ],
              [
                AppPerfAgent::Types::DISK,
                "system.disk.total_bytes",
                "#{disk.origin} - #{disk.type} (#{disk.mount})",
                disk.total_bytes
              ]
            ]
          }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Disk monitoring."
