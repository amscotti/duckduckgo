require "uri"
require "json"
require "./config"
require "./errors"
require "./http/adapter"
require "./http/default_adapter"
require "./params"
require "./types/instant_answer"

module DuckDuckGo
  class Client
    getter config : Config
    getter adapter : HTTP::Adapter

    def initialize(@config : Config = Config.new, adapter : HTTP::Adapter? = nil)
      @adapter = adapter || HTTP::DefaultAdapter.new(@config.timeout)
    end

    # Query the Instant Answer API
    def query(query : String, params : Params = Params.new) : InstantAnswer
      url = build_url(query, params)
      headers = build_headers

      response = adapter.get(url, headers)

      unless response.success?
        raise APIError.new("API request failed with status #{response.status_code}", response.status_code)
      end

      begin
        InstantAnswer.from_json(response.body)
      rescue ex : JSON::ParseException
        raise ParseError.new("Failed to parse API response: #{ex.message}", response.body)
      end
    end

    # Query with HTTPS (convenience method)
    def secure_query(query : String, params : Params = Params.new) : InstantAnswer
      original_secure = config.secure?
      config.secure = true
      begin
        query(query, params)
      ensure
        config.secure = original_secure
      end
    end

    private def build_url(query : String, params : Params) : String
      url_params = params.to_query_params
      url_params["q"] = query
      url_params["format"] = "json"

      if app_name = config.app_name
        url_params["t"] = app_name
      end

      # manual query string building to ensure correct encoding
      query_string = url_params.map { |k, v| "#{URI.encode_www_form(k)}=#{URI.encode_www_form(v)}" }.join("&")

      "#{config.base_url}?#{query_string}"
    end

    private def build_headers : ::HTTP::Headers
      ::HTTP::Headers{
        "User-Agent" => config.user_agent,
        "Accept"     => "application/json",
      }
    end
  end
end
