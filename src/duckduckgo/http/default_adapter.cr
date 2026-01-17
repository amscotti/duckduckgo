require "http/client"
require "./adapter"
require "../errors"

module DuckDuckGo
  module HTTP
    class DefaultAdapter < Adapter
      def initialize(@timeout : Time::Span = 10.seconds)
      end

      def get(url : String, headers : ::HTTP::Headers) : Response
        uri = URI.parse(url)

        client = ::HTTP::Client.new(uri)
        client.connect_timeout = @timeout
        client.read_timeout = @timeout

        begin
          response = client.get(uri.request_target, headers: headers)

          Response.new(
            status_code: response.status_code,
            body: response.body,
            headers: response.headers
          )
        rescue ex : IO::Error
          # Wrap connection errors
          raise ConnectionError.new("Connection failed: #{ex.message}", ex)
        rescue ex : Exception
          raise ConnectionError.new("HTTP request failed: #{ex.message}", ex)
        ensure
          client.try(&.close)
        end
      end
    end
  end
end
