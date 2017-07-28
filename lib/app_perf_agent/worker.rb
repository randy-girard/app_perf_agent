module AppPerfAgent
  class Worker
    def initialize
      @running = false
    end

    def load_plugins
      AppPerfAgent::Plugin.load_plugins
    end

    def dispatcher
      @dispatcher ||= AppPerfAgent::Dispatcher.new
    end

    def stop
      @running = false
    end

    def start
      @running = true

      while @running
        collect if dispatcher.queue_empty?

        if dispatcher.ready?
          dispatcher.dispatch
          dispatcher.reset
        end

        sleep 1
      end
    end

    def collect
      AppPerfAgent::Plugin.plugins.each do |plugin|
        items = plugin.call
        items.map {|i| AppPerfAgent.logger.debug i }
        Array(items).each do |item|
          type, name, label, value = item
          dispatcher.add_event(["metric", Time.now.to_f, {
            "type" => type,
            "name" => name,
            "label" => label,
            "value" => value
          }])
        end
      end
    end
  end
end
