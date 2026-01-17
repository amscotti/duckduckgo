module DuckDuckGo
  # Query parameters for API requests
  struct Params
    # Skip HTTP redirects for !bang commands
    property? no_redirect : Bool = false

    # Remove HTML from text
    property? no_html : Bool = false

    # Skip disambiguation (D) Type
    property? skip_disambig : Bool = false

    def initialize(
      @no_redirect : Bool = false,
      @no_html : Bool = false,
      @skip_disambig : Bool = false,
    )
    end

    # Convert to query string parameters
    def to_query_params : Hash(String, String)
      params = {} of String => String
      params["no_redirect"] = "1" if no_redirect?
      params["no_html"] = "1" if no_html?
      params["skip_disambig"] = "1" if skip_disambig?
      params
    end
  end
end
