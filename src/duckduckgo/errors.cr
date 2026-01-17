module DuckDuckGo
  # Base error class
  class Error < Exception
  end

  # HTTP/network errors
  class ConnectionError < Error
    getter cause : Exception?

    def initialize(message : String, @cause : Exception? = nil)
      super(message)
    end
  end

  # API returned an error status
  class APIError < Error
    getter status_code : Int32

    def initialize(message : String, @status_code : Int32)
      super(message)
    end
  end

  # JSON parsing failed
  class ParseError < Error
    getter body : String

    def initialize(message : String, @body : String)
      super(message)
    end
  end

  # Invalid argument provided
  class ArgumentError < Error
  end
end
