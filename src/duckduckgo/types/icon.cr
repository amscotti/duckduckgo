require "json"

module DuckDuckGo
  # Converter for Height/Width which can be int, string, or empty
  module FlexibleInt
    def self.from_json(pull : JSON::PullParser) : Int32
      case pull.kind
      when .int?
        pull.read_int.to_i32
      when .string?
        s = pull.read_string
        s.empty? ? 0 : s.to_i32
      else
        pull.read_null
        0
      end
    end

    def self.to_json(value : Int32, json : JSON::Builder)
      json.number(value)
    end
  end

  # Icon associated with topics/results
  struct Icon
    include JSON::Serializable

    @[JSON::Field(key: "URL")]
    getter url : String = ""

    @[JSON::Field(key: "Height", converter: DuckDuckGo::FlexibleInt)]
    getter height : Int32 = 0

    @[JSON::Field(key: "Width", converter: DuckDuckGo::FlexibleInt)]
    getter width : Int32 = 0

    def initialize
    end

    def empty? : Bool
      url.empty?
    end
  end
end
