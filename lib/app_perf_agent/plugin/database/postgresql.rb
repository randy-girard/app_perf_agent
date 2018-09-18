require "pg"
require_relative "../base"

module AppPerfAgent
  module Plugin
    module Database
      class Cpu < AppPerfAgent::Plugin::Base
        attr_accessor :last

        def initialize
          @connection = PG.connect( host: 'localhost', dbname: 'postgres' )
          super
        end

        def call
          databases.map {|dbname, dbsize|
            ["system.db.stats", dbsize, { "metric" => "size",
                                          "vendor" => "postgresql",
                                          "dbname" => dbname,
                                          "host" => AppPerfAgent.hostname }]
          }
        end

        def databases
          @connection
            .exec( "SELECT datname, pg_database_size(datname) as dbsize FROM pg_database WHERE datistemplate = false;" )
            .map {|row| row.values_at('datname', 'dbsize') }
        end
      end
    end
  end
end

AppPerfAgent.logger.info "Loading Postgresql monitoring."
