require 'helper'

describe "a RiakJson Document" do
  context "when initialized" do
    it "has a key" do
      test_key = 'key-123'
      doc = RiakJson::Document.new(test_key)
      doc.key.must_equal test_key
    end
    
    it "if created without a body parameter, initializes it to an empty hash" do
      doc = RiakJson::Document.new
      doc.body.must_be_kind_of Hash
      doc.body.must_be_empty
    end
    
    it "has a body" do
      test_key = 'key-123'
      test_body = { :field_one => '123', :field_two => 'abc' }
      doc = RiakJson::Document.new(test_key, test_body)
      doc.body.must_equal test_body
    end
    
    it "implements a .to_json method" do
      test_key = 'key-123'
      test_body = { :field_one => '123', :field_two => 'abc' }
      doc = RiakJson::Document.new(test_key, test_body)
      doc.to_json.must_be_kind_of String
      json_str = doc.to_json
      
      parsed_doc_body = JSON.parse(json_str)
      # Note - a parsed JSON document has keys as strings, not symbols
      parsed_doc_body['field_one'].must_equal '123'
    end
  end
end