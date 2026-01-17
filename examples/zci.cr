# Zero-Click Info (ZCI) Example
#
# Run with: crystal examples/zci.cr
#
# The zci method returns the best single text answer for a query.
# This is the simplest way to get quick information from DuckDuckGo.

require "../src/duckduckgo"

puts "=== DuckDuckGo Zero-Click Info ==="
puts
puts "The zci method returns the best single answer for any query."
puts

# Simple one-liner lookups
queries = [
  "Crystal programming language",
  "DuckDuckGo",
  "Albert Einstein",
  "what is my ip",
]

queries.each do |query|
  puts "Query: '#{query}'"
  puts "-" * 50
  answer = DuckDuckGo.zci(query)
  if answer.empty?
    puts "(No result)"
  else
    # Truncate long answers for display
    display = answer.size > 200 ? "#{answer[0..200]}..." : answer
    puts display
  end
  puts
end

# You can also get zci from an existing result
puts "=== Using zci on a result object ==="
puts
result = DuckDuckGo.query("Ruby programming language")
puts "Full query gives you access to all fields:"
puts "  Heading: #{result.heading}"
puts "  Type: #{result.type}"
puts "  Source: #{result.abstract_source}"
puts
puts "But zci gives you just the best answer:"
puts "  zci: #{result.zci[0..100]}..."
puts

puts "=== Done ==="
