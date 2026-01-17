require "../../spec_helper"

describe DuckDuckGo::Icon do
  it "handles numeric height/width" do
    json = %|{"URL": "http://example.com/icon.png", "Height": 16, "Width": 16}|
    icon = DuckDuckGo::Icon.from_json(json)

    icon.height.should eq(16)
    icon.width.should eq(16)
  end

  it "handles string height/width" do
    json = %|{"URL": "http://example.com/icon.png", "Height": "32", "Width": "32"}|
    icon = DuckDuckGo::Icon.from_json(json)

    icon.height.should eq(32)
    icon.width.should eq(32)
  end

  it "handles empty string height/width" do
    json = %|{"URL": "", "Height": "", "Width": ""}|
    icon = DuckDuckGo::Icon.from_json(json)

    icon.height.should eq(0)
    icon.width.should eq(0)
    icon.empty?.should be_true
  end
end
