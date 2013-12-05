require 'helper'

describe "a RiakJson Document" do
  context "when initialized" do
    it "has a key" do
      test_key = 'key-123'
      doc = RiakJson::Document.new(test_key)
      doc.key.must_equal test_key
    end
    
    it "has a body" do
      test_key = 'key-123'
      test_body = { :field_one => '123', :field_two => 'abc' }
      doc = RiakJson::Document.new(test_key, test_body)
      doc.body.must_equal test_body
    end
    
    it "implements a .to_json method"
  end
end