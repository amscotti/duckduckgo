require "json"
require "./icon"

module DuckDuckGo
  # A related topic or result
  struct Result
    include JSON::Serializable

    @[JSON::Field(key: "FirstURL")]
    getter first_url : String = ""

    @[JSON::Field(key: "Text")]
    getter text : String = ""

    @[JSON::Field(key: "Result")]
    getter result : String = ""

    @[JSON::Field(key: "Icon")]
    getter icon : Icon = Icon.new
  end
end
