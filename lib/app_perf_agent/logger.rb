require 'logger'

module AppPerfAgent
  class Logger
    def self.initialize_logger(log_target = STDOUT)
      oldlogger = defined?(@logger) ? @logger : nil
      @logger = ::Logger.new(log_target)
      @logger.level = ::Logger::INFO
      @logger
    end

    def self.logger
      defined?(@logger) ? @logger : initialize_logger
    end

    def self.logger=(log)
      @logger = (log ? log : ::Logger.new(File::NULL))
    end

    def logger
      AppPerfAgent::Logger.logger
    end
  end
end
