require "./adapter"

module DuckDuckGo
  module HTTP
    class MockAdapter < Adapter
      record StubbedResponse, pattern : Regex, response : Response
      record RecordedRequest, url : String, headers : ::HTTP::Headers

      getter requests : Array(RecordedRequest) = [] of RecordedRequest

      @stubs : Array(StubbedResponse) = [] of StubbedResponse
      @default_response : Response?

      def initialize
      end

      # Stub a response for URLs matching a pattern
      def stub(pattern : Regex, status_code : Int32 = 200, body : String = "", headers : ::HTTP::Headers = ::HTTP::Headers.new)
        @stubs << StubbedResponse.new(pattern, Response.new(status_code, body, headers))
        self
      end

      # Stub a response from a fixture file
      def stub_file(pattern : Regex, fixture_path : String, status_code : Int32 = 200)
        body = File.read(fixture_path)
        stub(pattern, status_code, body)
      end

      # Set default response when no stub matches
      def default(status_code : Int32 = 200, body : String = "")
        @default_response = Response.new(status_code, body)
        self
      end

      def get(url : String, headers : ::HTTP::Headers) : Response
        @requests << RecordedRequest.new(url, headers)

        @stubs.each do |stub|
          return stub.response if stub.pattern.matches?(url)
        end

        @default_response || raise "No stub found for URL: #{url}"
      end

      # Clear all stubs and recorded requests
      def reset
        @stubs.clear
        @requests.clear
        @default_response = nil
      end

      # Check if a URL was requested
      def requested?(pattern : Regex) : Bool
        @requests.any? { |request| pattern.matches?(request.url) }
      end

      # Get the last request
      def last_request : RecordedRequest?
        @requests.last?
      end
    end
  end
end
