require "./version"

module DuckDuckGo
  class Config
    # Use HTTPS (default: true)
    property? secure : Bool = true

    # User-Agent header
    property user_agent : String = "duckduckgo.cr/#{VERSION}"

    # HTTP timeout
    property timeout : Time::Span = 10.seconds

    # Application name (sent as 't' parameter)
    property app_name : String? = nil

    def initialize(
      @secure : Bool = true,
      @user_agent : String = "duckduckgo.cr/#{VERSION}",
      @timeout : Time::Span = 10.seconds,
      @app_name : String? = nil,
    )
    end

    # Base URL based on secure setting
    def base_url : String
      secure? ? "https://api.duckduckgo.com/" : "http://api.duckduckgo.com/"
    end
  end
end
