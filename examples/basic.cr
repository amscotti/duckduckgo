# Basic Usage Example
#
# Run with: crystal examples/basic.cr
#
# This example demonstrates basic queries to the DuckDuckGo Instant Answer API.

require "../src/duckduckgo"

puts "=== DuckDuckGo Basic Usage ==="
puts

# Simple topic query
puts "1. Topic Query: 'Crystal programming language'"
puts "-" * 50
result = DuckDuckGo.query("Crystal programming language")
puts "Heading: #{result.heading}"
puts "Type: #{result.type}"
puts "Source: #{result.abstract_source}"
puts "Abstract: #{result.abstract_text[0..200]}..." if result.abstract_text.size > 200
puts "URL: #{result.abstract_url}"
puts

# Query with instant answer
puts "2. Instant Answer: 'what is my ip'"
puts "-" * 50
result = DuckDuckGo.query("what is my ip")
if result.instant_answer?
  puts "Answer: #{result.answer}" unless result.answer.empty?
  puts "Answer Type: #{result.answer_type}"
else
  puts "No instant answer returned"
end
puts

# Another topic query
puts "3. Topic Query: 'DuckDuckGo'"
puts "-" * 50
result = DuckDuckGo.query("DuckDuckGo")
puts "Heading: #{result.heading}"
puts "Type: #{result.type}"
puts "Source: #{result.abstract_source}"
puts "Abstract: #{result.abstract_text[0..150]}..." if result.abstract_text.size > 150
puts

# Query with !bang redirect
puts "4. !Bang Redirect: '!g crystal lang'"
puts "-" * 50
result = DuckDuckGo.query("!g crystal lang", no_redirect: true)
if result.redirect?
  puts "Redirect URL: #{result.redirect}"
else
  puts "No redirect returned"
end
puts

# Quick one-liner using zci (zero-click info)
puts "5. Zero-Click Info (one-liner): 'Ruby programming'"
puts "-" * 50
puts DuckDuckGo.zci("Ruby programming language")[0..150] + "..."
puts

puts "=== Done ==="
