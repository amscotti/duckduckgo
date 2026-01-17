# Configuration Example
#
# Run with: crystal examples/configuration.cr
#
# This example demonstrates different ways to configure the client.

require "../src/duckduckgo"

puts "=== DuckDuckGo Configuration ==="
puts

# Method 1: Using global configuration
puts "1. Global Configuration"
puts "-" * 50

DuckDuckGo.configure do |config|
  config.secure = true
  config.user_agent = "MyApp/1.0 (Crystal Example)"
  config.timeout = 30.seconds
  config.app_name = "crystal_example"
end

result = DuckDuckGo.query("hello world")
puts "Query successful with global config"
puts "Heading: #{result.heading}"
puts

# Method 2: Creating a custom client
puts "2. Custom Client Instance"
puts "-" * 50

custom_config = DuckDuckGo::Config.new(
  secure: true,
  user_agent: "CustomClient/2.0",
  timeout: 15.seconds,
  app_name: "custom_client"
)

client = DuckDuckGo::Client.new(custom_config)
result = client.query("Crystal programming")
puts "Query successful with custom client"
puts "Heading: #{result.heading}"
puts

# Method 3: Query with different parameters
puts "3. Query Parameters"
puts "-" * 50

# Default query
result1 = DuckDuckGo.query("apple")
puts "Default query for 'apple': #{result1.type}"

# Skip disambiguation
result2 = DuckDuckGo.query("apple", skip_disambig: true)
puts "With skip_disambig: #{result2.type}"

# Get !bang redirect without following
result3 = DuckDuckGo.query("!g test", no_redirect: true)
puts "!bang with no_redirect: redirect? = #{result3.redirect?}"
puts

# Method 4: Error handling
puts "4. Error Handling"
puts "-" * 50

begin
  DuckDuckGo.query("test query")
  puts "Query successful"
rescue ex : DuckDuckGo::ConnectionError
  puts "Connection failed: #{ex.message}"
rescue ex : DuckDuckGo::APIError
  puts "API error (#{ex.status_code}): #{ex.message}"
rescue ex : DuckDuckGo::ParseError
  puts "Parse error: #{ex.message}"
end
puts

puts "=== Done ==="
