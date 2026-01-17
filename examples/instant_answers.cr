# Instant Answers Example
#
# Run with: crystal examples/instant_answers.cr
#
# This example demonstrates various instant answer queries.

require "../src/duckduckgo"

def try_instant_answer(query : String, description : String)
  puts "#{description}"
  puts "Query: '#{query}'"

  result = DuckDuckGo.query(query)

  if result.instant_answer?
    puts "Answer: #{result.answer}" unless result.answer.empty?
    puts "Type: #{result.answer_type}"
    puts "Heading: #{result.heading}" unless result.heading.empty?
  elsif !result.abstract_text.empty?
    puts "Abstract: #{result.abstract_text[0..100]}..."
  else
    puts "(No result returned)"
  end
  puts "-" * 50
  puts
end

puts "=== DuckDuckGo Instant Answers ==="
puts

# Calculator
try_instant_answer("2 + 2", "1. Calculator")
try_instant_answer("sqrt(144)", "2. Square Root")
try_instant_answer("15% of 200", "3. Percentage")

# Conversions
try_instant_answer("100 usd to eur", "4. Currency Conversion")
try_instant_answer("5 miles in km", "5. Unit Conversion")

# Random/Generation
try_instant_answer("password 16", "6. Password Generator (16 chars)")
try_instant_answer("random number 1-100", "7. Random Number")

# Information
try_instant_answer("what is my ip", "8. IP Address")
try_instant_answer("md5 hello", "9. MD5 Hash")

# Color
try_instant_answer("#FF5733", "10. Color Code")

puts "=== Done ==="
puts
puts "Note: Some instant answers depend on DuckDuckGo's backend"
puts "and may not always return results."
