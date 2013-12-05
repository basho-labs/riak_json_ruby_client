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
  
  context "uses the Client to read and write raw JSON objects to a collection" do
    it "gets a raw JSON object for a collection/key" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-123'

      # Test that a collection.insert_raw_json(doc) results in a call to client.insert_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :get_json_object, nil, [collection_name, test_key]
      collection.get_raw_json(test_key)
      collection.client.verify
    end
    
    it "inserts a raw JSON object into a collection/key" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object

      test_key = 'document-key-123'
      json_obj = { :key => test_key, :field_one => '123', :field_two => 'abc' }.to_json

      # Test that a collection.insert_raw_json(doc) results in a call to client.insert_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :insert_json_object, nil, [collection_name, test_key, json_obj]
      collection.insert_raw_json(test_key, json_obj)
      collection.client.verify
    end
    
    it "updates a raw JSON object into a collection/key" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
    
      test_key = 'document-key-123'
      json_obj = { :key => test_key, :field_one => '123', :field_two => 'abc' }.to_json
    
      # Test that a collection.update_raw_json(doc) results in a call to client.update_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :update_json_object, nil, [collection_name, test_key, json_obj]
      collection.update_raw_json(test_key, json_obj)
      collection.client.verify
    end
    
    it "deletes a raw JSON object for a collection/key" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-123'
    
      # Test that a collection.delete_raw_json(doc) results in a call to client.delete_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :delete_json_object, nil, [collection_name, test_key]
      collection.delete_raw_json(test_key)
      collection.client.verify
    end
  end
  
  context "administers Schemas for collections" do
    it "sets a schema object for a collection" do
      client = test_client
      collection_name = 'test_collection-new'
      collection = client.collection(collection_name)
      schema_json = [{
        :name => "field_one",
        :type => "string",
        :require => true
        }, {
        :name => "field_two",
        :type => "text",
        :require => false
        }].to_json
      
      collection.client = MiniTest::Mock.new
      collection.client.expect :set_schema_json, nil, [collection_name, schema_json]
      collection.set_schema(schema_json)
      collection.client.verify
    end
    
    it "gets a schema object for a collection" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)
      
      collection.client = MiniTest::Mock.new
      collection.client.expect :get_schema, nil, [collection_name]
      collection.get_schema
      collection.client.verify
    end
  end
  
  context "can read, write and delete Documents" do
    it "can insert a Document" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)

      # A Collection performs an insert by invoking doc.key and doc.to_json
      # and then sending along the raw json object to its client
      test_key = 'key-123'
      test_json = { :field_one => 'abc' }
      doc = RiakJson::Document.new(test_key, test_json)
      
      client = MiniTest::Mock.new
      client.expect :insert_json_object, nil, [collection_name, test_key, String]
      collection.client = client
      
      collection.insert(doc)
      client.verify
    end
  end
end