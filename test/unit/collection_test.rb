## ------------------------------------------------------------------- 
## 
## Copyright (c) "2013" Basho Technologies, Inc.
##
## This file is provided to you under the Apache License,
## Version 2.0 (the "License"); you may not use this file
## except in compliance with the License.  You may obtain
## a copy of the License at
##
##   http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing,
## software distributed under the License is distributed on an
## "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
## KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations
## under the License.
##
## -------------------------------------------------------------------

require 'helper'

describe "a RiakJson Collection" do
  context "when created" do
    it "has a name" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      collection.name.must_equal collection_name
    end

    it "requires a name" do
      client = rj_test_client  # in helper.rb
      lambda { client.collection() }.must_raise ArgumentError
    end

    it "cannot have an empty or nil name" do
      client = rj_test_client  # in helper.rb
      lambda { client.collection(nil) }.must_raise ArgumentError, "A collection cannot have a nil string name"
      lambda { client.collection('') }.must_raise ArgumentError, "A collection cannot have an empty string name"
    end
    
    it "has a client/connection" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      collection.client.must_be_kind_of(RiakJson::Client)
    end
  end
  
  context "uses the Client to read and write raw JSON objects to a collection" do
    it "gets a raw JSON object for a collection/key" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-123'

      # Test that a collection.insert_raw_json(doc) results in a call to client.insert_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :get_json_object, nil, [collection_name, test_key]
      collection.get_raw_json(test_key)
      collection.client.verify
    end
    
    it "inserts a raw JSON object into a collection/key" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)  # create a new collection object

      test_key = 'document-key-123'
      json_obj = { 'field_one' => '123', 'field_two' => 'abc' }.to_json

      # Test that a collection.insert_raw_json(doc) results in a call to client.insert_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :insert_json_object, nil, [collection_name, test_key, json_obj]
      collection.insert_raw_json(test_key, json_obj)
      collection.client.verify
    end
    
    it "updates a raw JSON object into a collection/key" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)  # create a new collection object
    
      test_key = 'document-key-123'
      json_obj = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
    
      # Test that a collection.update_raw_json(doc) results in a call to client.update_json_object
      collection.client = MiniTest::Mock.new
      collection.client.expect :update_json_object, nil, [collection_name, test_key, json_obj]
      collection.update_raw_json(test_key, json_obj)
      collection.client.verify
    end
    
    it "deletes a raw JSON object for a collection/key" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
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
      client = rj_test_client
      collection_name = 'ruby_test_collection-new'
      collection = client.collection(collection_name)
      collection.has_schema?.must_equal false
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
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)
      
      collection.client = MiniTest::Mock.new
      collection.client.expect :get_schema, nil, [collection_name]
      collection.get_schema
      collection.client.verify
    end
  end
  
  context "can write and delete Documents, and load them by key" do
    it "can load a document by its key" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)

      test_key = 'key-123'
      returned_json = '{"field_one": "abc"}' # Value mock-loaded from RiakJson
      
      client = MiniTest::Mock.new
      client.expect :get_json_object, returned_json, [collection_name, test_key]
      collection.client = client
      
      document = collection.find_by_key(test_key)
      client.verify
      document.must_be_kind_of RiakJson::Document
      document.key.must_equal test_key
    end
    
    it "can insert a Document" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)

      # A Collection performs an insert by invoking doc.key and doc.to_json
      # and then sending along the raw json object to its client
      test_key = 'key-123'
      test_json = { 'field_one' => 'abc' }
      doc = RiakJson::Document.new(test_key, test_json)
      
      client = MiniTest::Mock.new
      client.expect :insert_json_object, nil, [collection_name, test_key, String]
      collection.client = client
      
      collection.insert(doc)
      client.verify
    end
    
    it "can update a Document" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)
    
      # A Collection performs an update by invoking doc.key and doc.to_json
      # and then sending along the raw json object to its client
      test_key = 'key-123'
      test_json = { 'field_one' => 'abc' }
      doc = RiakJson::Document.new(test_key, test_json)
      
      client = MiniTest::Mock.new
      client.expect :update_json_object, nil, [collection_name, test_key, String]
      collection.client = client
      
      collection.update(doc)
      client.verify
    end
    
    it "can remove a Document" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)
    
      # A Collection performs a remove by invoking doc.key
      # and then sending along the key to its client
      test_key = 'key-123'
      doc = RiakJson::Document.new(test_key)
      
      client = MiniTest::Mock.new
      client.expect :delete_json_object, nil, [collection_name, test_key]
      collection.client = client
      
      collection.remove(doc)
      client.verify
    end
  end
  
  context "can query to find one or more documents" do
    it "can query for one document via an exact field match" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)

      query_json = {:company_name => 'Basho Technologies'}.to_json

      returned_json = '{"company_name": "Basho Technologies", "_id": "basho"}' # Value mock-loaded from RiakJson
        
      client = MiniTest::Mock.new
      client.expect :get_query_one, returned_json, [collection_name, query_json]
      collection.client = client
      
      document = collection.find_one(query_json)
      collection.client.verify
      
      document.must_be_kind_of RiakJson::Document
      document.key.must_equal "basho"
      document['company_name'].must_equal 'Basho Technologies'
    end
    
    it "returns an empty QueryResult if a find() call returns no documents" do
      client = rj_test_client
      collection_name = 'ruby_test_collection'
      collection = client.collection(collection_name)
      
      query = {:company_name => 'nonexistent'}.to_json
      returned_json = '[]'
      
      client = MiniTest::Mock.new
      client.expect :get_query_all, returned_json, [collection_name, query]
      collection.client = client
      document = collection.find(query)
      collection.client.verify
      
      # Now verify the same behavior when the json string returned from server is nil
      returned_json = nil
      client = MiniTest::Mock.new
      client.expect :get_query_all, returned_json, [collection_name, query]
      collection.client = client
      document = collection.find(query)
      collection.client.verify
    end
  end
  
  it "returns nil if a query_one() call finds no results" do
    client = rj_test_client
    collection_name = 'ruby_test_collection'
    collection = client.collection(collection_name)
    
    query_json = {:company_name => 'Basho Technologies'}.to_json
    empty_results_json = [].to_json  
    
    client = MiniTest::Mock.new
    client.expect :get_query_one, empty_results_json, [collection_name, query_json]
    collection.client = client
    
    doc = collection.find_one(query_json)
    collection.client.verify
    doc.must_be_nil
  end
end
