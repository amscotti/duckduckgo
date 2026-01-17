require "./duckduckgo/version"
require "./duckduckgo/errors"
require "./duckduckgo/config"
require "./duckduckgo/http/response"
require "./duckduckgo/http/adapter"
require "./duckduckgo/http/default_adapter"
require "./duckduckgo/http/mock_adapter"
require "./duckduckgo/params"
require "./duckduckgo/types/icon"
require "./duckduckgo/types/result"
require "./duckduckgo/types/topic_group"
require "./duckduckgo/types/instant_answer"
require "./duckduckgo/client"

module DuckDuckGo
  # Module-level client for convenience
  @@default_client : Client?

  # Configure the default client
  def self.configure(&) : Nil
    config = Config.new
    yield config
    @@default_client = Client.new(config)
  end

  # Get the default client (creates one if needed)
  def self.client : Client
    @@default_client ||= Client.new
  end

  # Query the Instant Answer API
  def self.query(
    query : String,
    no_redirect : Bool = false,
    no_html : Bool = false,
    skip_disambig : Bool = false,
  ) : InstantAnswer
    params = Params.new(
      no_redirect: no_redirect,
      no_html: no_html,
      skip_disambig: skip_disambig
    )
    client.query(query, params)
  end

  # Query using HTTPS
  def self.secure_query(
    query : String,
    no_redirect : Bool = false,
    no_html : Bool = false,
    skip_disambig : Bool = false,
  ) : InstantAnswer
    params = Params.new(
      no_redirect: no_redirect,
      no_html: no_html,
      skip_disambig: skip_disambig
    )
    client.secure_query(query, params)
  end

  # Get zero-click info - the best single text answer for a query
  # This is a convenience method that queries and returns the most relevant text.
  def self.zci(
    query_string : String,
    no_html : Bool = false,
    skip_disambig : Bool = false,
  ) : String
    query(query_string, no_html: no_html, skip_disambig: skip_disambig).zci
  end
end
