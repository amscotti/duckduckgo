require "../spec_helper"

describe DuckDuckGo::Client do
  describe "#query" do
    it "parses article response" do
      adapter = mock_adapter
      adapter.stub_file(/api\.duckduckgo\.com/, fixture_path("article.json"))

      client = DuckDuckGo::Client.new(adapter: adapter)
      result = client.query("crystal programming language")

      result.type.article?.should be_true
      result.heading.should eq("Crystal (programming language)")
      result.abstract_source.should eq("Wikipedia")
      result.abstract_text.should_not be_empty
    end

    it "parses disambiguation response" do
      adapter = mock_adapter
      adapter.stub_file(/api\.duckduckgo\.com/, fixture_path("disambiguation.json"))

      client = DuckDuckGo::Client.new(adapter: adapter)
      result = client.query("apple")

      result.type.disambiguation?.should be_true
      result.topic_groups.should_not be_empty
      result.topic_groups.first.name.should eq("Companies")
    end

    it "handles instant answers" do
      adapter = mock_adapter
      adapter.stub_file(/api\.duckduckgo\.com/, fixture_path("instant_answer_calc.json"))

      client = DuckDuckGo::Client.new(adapter: adapter)
      result = client.query("2+2")

      result.instant_answer?.should be_true
      result.answer.should eq("4")
      result.answer_type.calc?.should be_true
    end

    it "handles !bang redirects" do
      adapter = mock_adapter
      adapter.stub_file(/api\.duckduckgo\.com/, fixture_path("bang_redirect.json"))

      client = DuckDuckGo::Client.new(adapter: adapter)
      result = client.query("!imdb matrix", DuckDuckGo::Params.new(no_redirect: true))

      result.redirect?.should be_true
      result.redirect.should contain("imdb.com")
    end

    it "builds correct URL with parameters" do
      adapter = mock_adapter
      adapter.stub(/.*/, 200, "{}")

      client = DuckDuckGo::Client.new(adapter: adapter)
      client.query("test", DuckDuckGo::Params.new(no_redirect: true, no_html: true))

      request = adapter.last_request
      request.should_not be_nil
      if req = request
        req.url.should contain("no_redirect=1")
        req.url.should contain("no_html=1")
        req.url.should contain("format=json")
      end
    end

    it "raises APIError on non-2xx response" do
      adapter = mock_adapter
      adapter.stub(/.*/, 500, "Internal Server Error")

      client = DuckDuckGo::Client.new(adapter: adapter)

      expect_raises(DuckDuckGo::APIError) do
        client.query("test")
      end
    end

    it "raises ParseError on invalid JSON" do
      adapter = mock_adapter
      adapter.stub(/.*/, 200, "not valid json")

      client = DuckDuckGo::Client.new(adapter: adapter)

      expect_raises(DuckDuckGo::ParseError) do
        client.query("test")
      end
    end
  end
end
