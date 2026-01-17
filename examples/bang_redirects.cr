# !Bang Redirects Example
#
# Run with: crystal examples/bang_redirects.cr
#
# This example demonstrates !bang redirect queries.
# !Bangs are shortcuts that redirect to other sites.

require "../src/duckduckgo"

def try_bang(query : String, description : String)
  puts "#{description}"
  puts "Query: '#{query}'"

  # Use no_redirect: true to get the URL without following the redirect
  result = DuckDuckGo.query(query, no_redirect: true)

  if result.redirect?
    puts "Redirect URL: #{result.redirect}"
  else
    puts "(No redirect returned)"
  end
  puts "-" * 50
  puts
end

puts "=== DuckDuckGo !Bang Redirects ==="
puts
puts "!Bangs are shortcuts that redirect searches to other sites."
puts "Use no_redirect: true to get the URL without following it."
puts
puts "=" * 50
puts

# Popular !bangs
try_bang("!g crystal programming", "1. Google Search (!g)")
try_bang("!w crystal language", "2. Wikipedia (!w)")
try_bang("!yt crystal tutorial", "3. YouTube (!yt)")
try_bang("!gh crystal-lang/crystal", "4. GitHub (!gh)")
try_bang("!so crystal array slice", "5. Stack Overflow (!so)")
try_bang("!a crystal book", "6. Amazon (!a)")
try_bang("!imdb the matrix", "7. IMDB (!imdb)")
try_bang("!maps new york", "8. Google Maps (!maps)")

puts "=== Done ==="
puts
puts "DuckDuckGo supports thousands of !bangs."
puts "See the full list at: https://duckduckgo.com/bangs"
