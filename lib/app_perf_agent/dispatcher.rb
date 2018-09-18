require 'net/http'
require 'msgpack'
require 'base64'

module AppPerfAgent
  class Dispatcher
    def initialize
      @start_time = Time.now
      @queue = Queue.new
      @tags = []
    end

    def add_event(event)
      @queue << event
    end

    def add_tag(key, value)
      tag = @tags.find {|tag| tag[1] == key && tag[2] == value }

      if tag
        tag[0]
      else
        index = @tags.size
        @tags << [index, key, value]
        index
      end
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
      @tags = []
      @start_time = Time.now
    end

    def dispatch
      begin
        data = drain
        dispatch_events(data.dup)
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
      hash = {
        "metrics" => data["metrics"],
        "tags" => data["tags"]
      }

      AppPerfAgent.logger.info "Dispatching Data: #{hash}"

      body = MessagePack.pack(hash)

      compressed_body = Zlib::Deflate.deflate(body, Zlib::DEFAULT_COMPRESSION)
      Base64.encode64(compressed_body)
    end

    def drain
      {
        "metrics" => Array.new(@queue.size) { @queue.pop },
        "tags" => @tags
      }
    end

    def url
      @url ||= "http://#{AppPerfAgent.options[:host]}/api/listener/#{AppPerfAgent.options[:license_key]}"
    end
  end
end
