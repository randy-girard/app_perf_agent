require_relative  "app_perf_agent/types"
require_relative  "app_perf_agent/logger"
require_relative  "app_perf_agent/plugin"
require_relative  "app_perf_agent/dispatcher"
require_relative  "app_perf_agent/worker"

module AppPerfAgent
  DEFAULTS = {
    environment: nil,
    daemon: false,
    host: 'localhost:5000',
    ssl: false,
    license_key: '',
    pidfile: File.dirname(__FILE__) + "/../app_perf_agent.pid"
  }

  def self.hostname
    @hostname ||= Socket.gethostname
  end

  def self.options
    @options ||= DEFAULTS.dup
  end

  def self.options=(opts)
    @options = opts
  end

  def self.logger
    AppPerfAgent::Logger.logger
  end

  def self.logger=(log)
    AppPerfAgent::Logger.logger = log
  end

  class << self
    def load
      AppPerfAgent::Agent::Plugin.load_plugins
    end
  end
end
