require "./response"

module DuckDuckGo
  module HTTP
    # Abstract HTTP adapter for dependency injection
    abstract class Adapter
      abstract def get(url : String, headers : ::HTTP::Headers) : Response
    end
  end
end
