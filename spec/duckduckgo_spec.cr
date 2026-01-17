require "./spec_helper"

describe DuckDuckGo do
  it "has a version" do
    DuckDuckGo::VERSION.should_not be_nil
  end
end
