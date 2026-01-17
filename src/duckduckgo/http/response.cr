require "http/headers"

module DuckDuckGo
  module HTTP
    # Response wrapper
    struct Response
      getter status_code : Int32
      getter body : String
      getter headers : ::HTTP::Headers

      def initialize(@status_code : Int32, @body : String, @headers : ::HTTP::Headers = ::HTTP::Headers.new)
      end

      def success? : Bool
        (200..299).includes?(status_code)
      end
    end
  end
end
