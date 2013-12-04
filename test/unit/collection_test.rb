require 'helper'

describe "a RiakJson Collection" do
  context "when created" do
    it "has a name" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      collection.name.must_equal collection_name
    end

    it "requires a name" do
      client = test_client  # in helper.rb
      lambda { client.collection() }.must_raise ArgumentError
    end

    it "cannot have an empty or nil name" do
      client = test_client  # in helper.rb
      lambda { client.collection(nil) }.must_raise ArgumentError, "A collection cannot have a nil string name"
      lambda { client.collection('') }.must_raise ArgumentError, "A collection cannot have an empty string name"
    end
    
    it "has a client/connection" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      collection.client.must_be_kind_of(RiakJson::Client)
    end
  end
  
  context "uses a RiakJson Client to" do
    it "insert a JSON document into a collection/key" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object

      test_key = 'document-key-123'
      document = { :key => test_key, :field_one => '123', :field_two => 'abc' }.to_json

      # Test that a collection.insert(doc) results in a call to client.insert_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :insert_json_object, nil, [collection_name, test_key, document]
      collection.insert(document)
      collection.client.verify
    end
  end
end