require 'net/http'
require 'oj'
require 'base64'

module AppPerfAgent
  class Dispatcher
    def initialize
      @start_time = Time.now
      @queue = Queue.new
    end

    def add_event(event)
      @queue << event
    end

    def queue_empty?
      @queue.size.to_i == 0
    end

    def dispatch_interval
      30
    end

    def ready?
      Time.now > @start_time + dispatch_interval.to_f && !queue_empty?
    end

    def reset
      @queue.clear
      @start_time = Time.now
    end

    def dispatch
      begin
        events = drain(@queue)
        dispatch_events(events.dup)
      rescue => ex
        ::AppPerfAgent.logger.error "#{ex.inspect}"
        ::AppPerfAgent.logger.error "#{ex.backtrace.inspect}"
      ensure
        reset
      end
    end

    private

    def dispatch_events(data)
      if data && data.length > 0
        uri = URI(url)

        sock = Net::HTTP.new(uri.host, uri.port)
        sock.use_ssl = AppPerfAgent.options[:ssl]

        req = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json", "Accept-Encoding" => "gzip", "User-Agent" => "gzip" })
        req.body = compress_body(data)
        req.content_type = "application/octet-stream"

        res = sock.start do |http|
          http.read_timeout = 30
          http.request(req)
        end
        data.clear
      end
    end

    def compress_body(data)
      body = Oj.dump({
        "host" => AppPerfAgent.hostname,
        "data" => data
      })

      compressed_body = Zlib::Deflate.deflate(body, Zlib::DEFAULT_COMPRESSION)
      Base64.encode64(compressed_body)
    end

    def drain(queue)
      Array.new(queue.size) { queue.pop }
    end

    def url
      @url ||= "http://#{AppPerfAgent.options[:host]}/api/listener/2/#{AppPerfAgent.options[:license_key]}"
    end
  end
end
