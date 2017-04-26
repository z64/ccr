require "yaml"

module Ccr
  struct Config
    YAML.mapping({
      client_id: {type: UInt64, converter: SnowflakeConverter},
      token:     String,
      osu_token: String,
    })

    def self.from_file(filename : String)
      Config.from_yaml File.read(filename)
    end
  end

  module SnowflakeConverter
    def self.from_yaml(parser)
      value = parser.read_raw

      UInt64.new value
    end
  end
end
