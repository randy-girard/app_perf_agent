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
          key, value, tags = item
          indexed_tags = tags.map {|(key, value)| dispatcher.add_tag(key, value) }
          metric = [Time.now.to_f, key, indexed_tags || [], 1, value, []]
          dispatcher.add_event(metric)
        end
      end
    end
  end
end
