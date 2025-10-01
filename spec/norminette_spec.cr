require "./spec_helper"
require "json"

describe Norminette do
  # TODO: Probably need more tests.
  it "connection" do
    connected = false
    test = Norminette::Sender.new ->(result : JSON::Any) do
      connected = true if result["display"].as_s?
    end

    test.publish({action: "version"}.to_json)
    test.sync
    connected.should eq(true)
  end
end
