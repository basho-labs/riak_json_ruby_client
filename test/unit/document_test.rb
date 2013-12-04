require 'helper'

describe "a RiakJson Document" do
  context "when initialized" do
    it "has a key" do
      test_key = 'key-123'
      doc = RiakJson::Document.new(test_key)
      doc.key.must_equal test_key
    end
  end
end