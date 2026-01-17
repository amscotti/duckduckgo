# Response Types Example
#
# Run with: crystal examples/response_types.cr
#
# This example demonstrates handling different response types from the API.

require "../src/duckduckgo"

def display_result(query : String, no_redirect : Bool = false)
  puts "Query: '#{query}'"
  puts "-" * 50

  result = DuckDuckGo.query(query, no_redirect: no_redirect)

  # Check for redirects first (can occur with any type)
  if result.redirect?
    puts "Type: Redirect (!bang)"
    puts "Redirect URL: #{result.redirect}"
    puts
    return
  end

  case result.type
  when .article?
    puts "Type: Article"
    puts "Heading: #{result.heading}"
    puts "Source: #{result.abstract_source}"
    puts "Summary: #{result.abstract_text[0..150]}..." if result.abstract_text.size > 150
    puts "Image: #{result.image}" unless result.image.empty?
  when .disambiguation?
    puts "Type: Disambiguation"
    puts "Heading: #{result.heading}"
    puts "This query has multiple meanings:"
    puts

    # Show grouped topics
    result.topic_groups.each do |group|
      puts "  #{group.name}:"
      group.topics.first(3).each do |topic|
        puts "    - #{topic.text[0..80]}..."
      end
    end

    # Show ungrouped topics
    ungrouped = result.related_topics.select(DuckDuckGo::Result)
    unless ungrouped.empty?
      puts "  Other:"
      ungrouped.first(3).each do |topic|
        puts "    - #{topic.text[0..80]}..."
      end
    end
  when .category?
    puts "Type: Category"
    puts "Heading: #{result.heading}"
    puts "Items:"
    result.flat_related_topics.first(5).each do |topic|
      puts "  - #{topic.text[0..80]}..."
    end
  when .exclusive?
    puts "Type: Exclusive (Instant Answer)"
    puts "Answer: #{result.answer}"
    puts "Answer Type: #{result.answer_type}"
  when .name?
    puts "Type: Name"
    puts "Heading: #{result.heading}"
    puts "Entity: #{result.entity}" unless result.entity.empty?
  when .none?
    puts "Type: None (no results)"
  end

  puts
end

puts "=== DuckDuckGo Response Types ==="
puts

# Article - well-known topic
display_result("Albert Einstein")

# Article - programming language
display_result("Crystal programming language")

# Article - company
display_result("DuckDuckGo")

# Instant Answer - IP lookup
display_result("what is my ip")

# !Bang redirect (requires no_redirect: true)
display_result("!w Crystal language", no_redirect: true)

puts "=== Done ==="
puts
puts "Note: Disambiguation and Category responses depend on DuckDuckGo's"
puts "data sources and may not always be available for all queries."
