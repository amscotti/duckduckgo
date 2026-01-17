require "spec"
require "../src/duckduckgo"

def fixture_path(name : String) : String
  File.join(__DIR__, "../spec/fixtures", name)
end

def load_fixture(name : String) : String
  File.read(fixture_path(name))
end

def mock_adapter : DuckDuckGo::HTTP::MockAdapter
  DuckDuckGo::HTTP::MockAdapter.new
end
