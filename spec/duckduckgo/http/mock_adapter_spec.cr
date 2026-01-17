require "../../spec_helper"

describe DuckDuckGo::HTTP::MockAdapter do
  it "returns stubbed response" do
    adapter = mock_adapter
    adapter.stub(/test/, 200, "OK")

    response = adapter.get("http://example.com/test", HTTP::Headers.new)
    response.status_code.should eq(200)
    response.body.should eq("OK")
  end

  it "returns default response if no stub matches" do
    adapter = mock_adapter
    adapter.default(404, "Not Found")

    response = adapter.get("http://example.com/unknown", HTTP::Headers.new)
    response.status_code.should eq(404)
    response.body.should eq("Not Found")
  end

  it "records requests" do
    adapter = mock_adapter
    adapter.default(200)

    adapter.get("http://example.com/1", HTTP::Headers.new)
    adapter.get("http://example.com/2", HTTP::Headers.new)

    adapter.requests.size.should eq(2)
    request = adapter.last_request
    request.should_not be_nil
    if req = request
      req.url.should eq("http://example.com/2")
    end
  end

  it "raises if no stub and no default" do
    adapter = mock_adapter
    expect_raises(Exception, "No stub found") do
      adapter.get("http://example.com/fail", HTTP::Headers.new)
    end
  end
end
