require "json"
require "./result"

module DuckDuckGo
  # Grouped topics for disambiguation pages
  struct TopicGroup
    include JSON::Serializable

    @[JSON::Field(key: "Name")]
    getter name : String = ""

    @[JSON::Field(key: "Topics")]
    getter topics : Array(Result) = [] of Result
  end
end
