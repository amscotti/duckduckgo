require "json"
require "./icon"
require "./result"
require "./topic_group"

module DuckDuckGo
  # Response type categories
  enum ResponseType
    Article        # A - Topic with abstract
    Disambiguation # D - Multiple meanings
    Category       # C - List of items
    Name           # N - Person/entity
    Exclusive      # E - Instant answer only
    None           # Empty - no results or redirect

    def self.from_string(s : String) : ResponseType
      case s
      when "A" then Article
      when "D" then Disambiguation
      when "C" then Category
      when "N" then Name
      when "E" then Exclusive
      else          None
      end
    end
  end

  # Instant answer types
  enum AnswerType
    None
    Calc
    Color
    Digest
    Info
    IP
    IPLoc
    Phone
    Password
    Random
    Regexp
    Unicode
    UPC
    Zip
    Other
  end

  # Mapping from API strings to AnswerType enum values
  ANSWER_TYPE_MAPPING = {
    ""        => AnswerType::None,
    "calc"    => AnswerType::Calc,
    "color"   => AnswerType::Color,
    "digest"  => AnswerType::Digest,
    "info"    => AnswerType::Info,
    "ip"      => AnswerType::IP,
    "iploc"   => AnswerType::IPLoc,
    "phone"   => AnswerType::Phone,
    "pw"      => AnswerType::Password,
    "rand"    => AnswerType::Random,
    "regexp"  => AnswerType::Regexp,
    "unicode" => AnswerType::Unicode,
    "upc"     => AnswerType::UPC,
    "zip"     => AnswerType::Zip,
  }

  # Extension to add from_string method
  enum AnswerType
    def self.from_string(s : String) : AnswerType
      ANSWER_TYPE_MAPPING[s.downcase]? || Other
    end
  end

  # Converter for Answer field which can be a string or an object
  module FlexibleAnswer
    def self.from_json(pull : JSON::PullParser) : String
      case pull.kind
      when .string?
        pull.read_string
      when .begin_object?
        # Read the object as raw JSON and extract useful info
        json_str = pull.read_raw
        parsed = JSON.parse(json_str)
        # Try to get a meaningful string from the object
        if result = parsed["result"]?
          result.as_s? || ""
        elsif name = parsed["name"]?
          name.as_s? || ""
        else
          ""
        end
      else
        pull.read_null
        ""
      end
    end

    def self.to_json(value : String, json : JSON::Builder)
      json.string(value)
    end
  end

  # Union type for RelatedTopics entries (can be Result or TopicGroup)
  alias RelatedTopicEntry = Result | TopicGroup

  # Custom converter for RelatedTopics array
  module RelatedTopicsConverter
    def self.from_json(pull : JSON::PullParser) : Array(RelatedTopicEntry)
      results = [] of RelatedTopicEntry
      pull.read_array do
        # Peek to determine type - if has "Topics" key, it's a group
        json_str = pull.read_raw
        parsed = JSON.parse(json_str)
        if parsed.as_h.has_key?("Topics")
          results << TopicGroup.from_json(json_str)
        else
          results << Result.from_json(json_str)
        end
      end
      results
    end

    def self.to_json(value : Array(RelatedTopicEntry), json : JSON::Builder)
      json.array do
        value.each do |entry|
          entry.to_json(json)
        end
      end
    end
  end

  # The main response from the Instant Answer API
  struct InstantAnswer
    include JSON::Serializable

    # Topic summary (may contain HTML)
    @[JSON::Field(key: "Abstract")]
    getter abstract : String = ""

    # Topic summary (plain text)
    @[JSON::Field(key: "AbstractText")]
    getter abstract_text : String = ""

    # Source of the abstract (e.g., "Wikipedia")
    @[JSON::Field(key: "AbstractSource")]
    getter abstract_source : String = ""

    # URL to the abstract source
    @[JSON::Field(key: "AbstractURL")]
    getter abstract_url : String = ""

    # Image URL associated with abstract
    @[JSON::Field(key: "Image")]
    getter image : String = ""

    # Topic name/title
    @[JSON::Field(key: "Heading")]
    getter heading : String = ""

    # Instant answer text (can be string or object in API, normalized to string)
    @[JSON::Field(key: "Answer", converter: DuckDuckGo::FlexibleAnswer)]
    getter answer : String = ""

    # Type of instant answer (raw string)
    @[JSON::Field(key: "AnswerType")]
    getter answer_type_raw : String = ""

    # Dictionary definition
    @[JSON::Field(key: "Definition")]
    getter definition : String = ""

    # Source of definition
    @[JSON::Field(key: "DefinitionSource")]
    getter definition_source : String = ""

    # URL to definition source
    @[JSON::Field(key: "DefinitionURL")]
    getter definition_url : String = ""

    # Response type (raw string)
    @[JSON::Field(key: "Type")]
    getter type_raw : String = ""

    # Redirect URL for !bang commands
    @[JSON::Field(key: "Redirect")]
    getter redirect : String = ""

    # Related topics
    @[JSON::Field(key: "RelatedTopics", converter: DuckDuckGo::RelatedTopicsConverter)]
    getter related_topics : Array(RelatedTopicEntry) = [] of RelatedTopicEntry

    # External results (rare)
    @[JSON::Field(key: "Results")]
    getter results : Array(Result) = [] of Result

    # Additional fields that appear in some responses
    @[JSON::Field(key: "Entity")]
    getter entity : String = ""

    @[JSON::Field(key: "ImageWidth", converter: DuckDuckGo::FlexibleInt)]
    getter image_width : Int32 = 0

    @[JSON::Field(key: "ImageHeight", converter: DuckDuckGo::FlexibleInt)]
    getter image_height : Int32 = 0

    @[JSON::Field(key: "ImageIsLogo", converter: DuckDuckGo::FlexibleInt)]
    getter image_is_logo : Int32 = 0

    @[JSON::Field(key: "Infobox")]
    getter infobox : JSON::Any = JSON::Any.new(nil)

    # Computed properties

    # Response type as enum
    def type : ResponseType
      ResponseType.from_string(type_raw)
    end

    # Answer type as enum
    def answer_type : AnswerType
      AnswerType.from_string(answer_type_raw)
    end

    # Check if this is a disambiguation page
    def disambiguation? : Bool
      type.disambiguation?
    end

    # Check if this is an article
    def article? : Bool
      type.article?
    end

    # Check if this is a category
    def category? : Bool
      type.category?
    end

    # Check if this has an instant answer
    def instant_answer? : Bool
      !answer.empty? || !answer_type_raw.empty?
    end

    # Check if this is a !bang redirect
    def redirect? : Bool
      !redirect.empty?
    end

    # Check if there are any results
    def has_results? : Bool
      !abstract_text.empty? || !answer.empty? || !definition.empty? ||
        !related_topics.empty? || !redirect.empty?
    end

    # Get only Result entries from related_topics (not TopicGroups)
    def flat_related_topics : Array(Result)
      related_topics.reduce([] of Result) do |acc, entry|
        case entry
        when Result
          acc << entry
        when TopicGroup
          acc.concat(entry.topics)
        end
        acc
      end
    end

    # Get topic groups (for disambiguation pages)
    def topic_groups : Array(TopicGroup)
      related_topics.select(TopicGroup)
    end

    # Get the best single text answer (zero-click info)
    # Returns the most relevant text based on response type priority:
    # 1. Abstract text (articles)
    # 2. Answer (instant answers)
    # 3. Definition
    # 4. First related topic text
    # 5. Redirect URL (!bangs)
    def zci : String
      return abstract_text unless abstract_text.empty?
      return answer unless answer.empty?
      return definition unless definition.empty?

      if first_topic = flat_related_topics.first?
        return first_topic.text unless first_topic.text.empty?
      end

      return redirect unless redirect.empty?

      ""
    end
  end
end
