require 'helper'

describe "a RiakJson Client" do
  context "when created" do
    it "has an empty collection cache" do
      client = RiakJson::Client.new
      client.collection_cache.must_be_empty
    end
  end
end