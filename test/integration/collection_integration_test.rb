require 'helper'

describe "a RiakJson Collection" do
  context "uses a RiakJson client to" do
    it "insert a raw json object" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-123'
      json_obj = { :key => test_key, :field_one => '123', :field_two => 'abc' }.to_json
      response = collection.insert_raw_json(test_key, json_obj)
      response.code.must_equal 204
    end
    it "insert a new document"
    it "update an existing document"
    it "read an existing document"
  end

  context "performs queries" do
    it "retrieves a single document with find_one()"
    it "retrieves many documents with find()"
  end
end