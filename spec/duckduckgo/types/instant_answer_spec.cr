require "../../spec_helper"

describe DuckDuckGo::InstantAnswer do
  describe ".from_json" do
    it "parses all fields correctly" do
      json = load_fixture("article.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      result.abstract.should_not be_empty
      result.abstract_text.should_not be_empty
      result.abstract_source.should eq("Wikipedia")
      result.type.should eq(DuckDuckGo::ResponseType::Article)
    end

    it "handles empty responses" do
      json = load_fixture("empty_response.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      result.has_results?.should be_false
      result.type.should eq(DuckDuckGo::ResponseType::None)
    end

    it "handles mixed RelatedTopics (Results and TopicGroups)" do
      json = load_fixture("disambiguation.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      result.related_topics.should_not be_empty
      result.topic_groups.should_not be_empty
      result.flat_related_topics.should_not be_empty
    end
  end

  describe "#flat_related_topics" do
    it "flattens grouped topics" do
      json = load_fixture("disambiguation.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      flat = result.flat_related_topics
      flat.should be_a(Array(DuckDuckGo::Result))
      # In disambiguation.json:
      # 1 group with 1 topic
      # 1 ungrouped topic
      # Total 2 topics
      flat.size.should eq(2)
    end
  end

  describe "#zci" do
    it "returns abstract_text for articles" do
      json = load_fixture("article.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      result.zci.should eq(result.abstract_text)
      result.zci.should_not be_empty
    end

    it "returns answer for instant answers" do
      json = load_fixture("instant_answer_calc.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      result.zci.should eq("4")
    end

    it "returns first topic text for disambiguation" do
      json = load_fixture("disambiguation.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      # Abstract is empty for disambiguation, so zci falls through to topics
      result.zci.should_not be_empty
      result.zci.should eq(result.flat_related_topics.first.text)
    end

    it "returns redirect for bang queries" do
      json = load_fixture("bang_redirect.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      result.zci.should contain("imdb.com")
    end

    it "returns empty string for empty responses" do
      json = load_fixture("empty_response.json")
      result = DuckDuckGo::InstantAnswer.from_json(json)

      result.zci.should eq("")
    end
  end
end
