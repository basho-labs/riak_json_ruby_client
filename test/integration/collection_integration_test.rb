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
  context "uses a RiakJson client to perform CRUD on raw JSON objects" do
    it "inserts a raw json object with a key" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-123'
      json_obj = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
      key = collection.insert_raw_json(test_key, json_obj)
      key.must_equal test_key
    end
    
    it "updates a raw json object" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-update'
      # Insert an object first
      json_obj_initial = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
      collection.insert_raw_json(test_key, json_obj_initial)
      
      # Now update the object
      json_obj_modified = { 'field_one' => '345', 'field_two' => 'efg' }.to_json
      collection.update_raw_json(test_key, json_obj_modified)
    end
    
    it "deletes a raw json object" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-delete'
      # Insert an object first
      json_obj = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
      collection.insert_raw_json(test_key, json_obj)
      
      # Now delete that object
      collection.delete_raw_json(test_key)
      
      # Issue a get to make sure it now returns a 404 / Resource not found exception
      lambda { collection.get_raw_json(test_key) }.must_raise RestClient::ResourceNotFound
    end
  end
  
  context "uses a RiakJson client to perform CRUD on RiakJson Documents" do
    it "inserts a new document with a key" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)

      test_key = 'key-123'
      test_body = { 'field_one' => 'abc' }
      doc = RiakJson::Document.new(test_key, test_body)
      key = collection.insert(doc)
      key.must_equal test_key
    end
    
    it "inserts a new document with no key, receives key from RiakJson" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)

      test_body = { 'field_one' => 'abc' }
      doc = RiakJson::Document.new
      doc.body = test_body
      doc.key.must_be_nil
      
      # Insert the document, get key back from db
      generated_key = collection.insert(doc)
      # The insert() operation should initialize the document's key field
      doc.key.must_equal generated_key
    end
    
    it "updates an existing document" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)

      test_key = 'key-123'
      test_body = { 'field_one' => 'abc' }
      doc = RiakJson::Document.new(test_key, test_body)
      collection.update(doc)
    end
    
    it "reads an existing document (loads it by key)" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)

      # First, insert the document that's to be read
      test_key = 'key-123'
      test_body = { 'field_one' => 'abc' }
      doc = RiakJson::Document.new(test_key, test_body)
      collection.update(doc)

      loaded_doc = collection.find_by_key(test_key)
      loaded_doc.must_be_kind_of RiakJson::Document
      loaded_doc['field_one'].must_equal 'abc'
    end
  end
  
  context "can set, read and delete schemas" do
    it "can use a raw JSON object to set schema" do
      client = test_client
      collection = client.collection('cities')

      schema = [{
           :name => "city",
           :type => "text",
           :require => true
          }, {
            :name => "state",
            :type => "string",
            :require => true
          }, {
            :name => "zip_codes",
            :type => "multi_string",
            :require => false
          }, {
            :name => "population",
            :type => "integer",
            :require => false
          }, {
            :name => "country",
            :type => "string",
            :require => true
          }].to_json
      response = collection.set_schema(schema)
      response.code.must_equal 204
    end
    
    it "uses a CollectionSchema object to set schemas" do
      client = test_client
      collection = client.collection('cities')
      
      schema = RiakJson::CollectionSchema.new
      schema.add_text_field(name='city', required=true)
      schema.add_string_field('state', true)
      schema.add_multi_string_field('zip_codes') # required: false 
      schema.add_integer_field('population', false)
      schema.add_string_field('country', true)
      
      response = collection.set_schema(schema)
      response.code.must_equal 204
    end
    
    it "can delete (unset) a schema for a collection" do
      client = test_client
      collection = client.collection('cities-delete-schema')
      
      # Ensure a collection has an existing schema
      schema = RiakJson::CollectionSchema.new
      schema.add_text_field(name='city', required=true)
      response = collection.set_schema(schema)
      response.code.must_equal 204
      
      # Delete the schema
      response = collection.delete_schema
      response.code.must_equal 204
      
    end
  end
  
  context "performs queries" do
    it "retrieves a single document with find_one()" do
      client = test_client
      collection = client.collection('cities')
      key = "nyc"
      body = { 'city' => "New York", 'state' => "NY", 'country' => "USA" }
      doc = RiakJson::Document.new(key, body)
      collection.insert(doc)
      
      result_doc = collection.find_one({"city" => "New York"}.to_json)
      result_doc.key.must_equal "nyc"
    end
    
    it "retrieves many documents with find()" do
      client = test_client
      collection = client.collection('cities')
      
      # Populate the cities collection with data
      doc = RiakJson::Document.new(
        key="nyc",
        body={ 'city'=>"New York", 'state'=>"NY", 'country'=>"USA" })
      collection.insert(doc)
      doc = RiakJson::Document.new(
        key="boston",
        body={ 'city'=>"Boston", 'state'=>"MA", 'country'=>"USA" })
      collection.insert(doc)
      doc = RiakJson::Document.new(
        key="sf",
        body={ 'city'=>"San Francisco", 'state'=>"CA", 'country'=>"USA" })
      collection.insert(doc)
      
      results = collection.find({'country'=>'USA'}.to_json)
      results.num_pages.must_equal 1  # Total number of pages in result set
      results.page.must_equal 0  # Current page, zero-indexed
      results.total.must_equal 3  # Total number of documents in result set
      results.per_page.must_be :>, 0  # defaults to 100
      
      results.documents.count.must_equal 3
      results.documents[0].must_be_kind_of RiakJson::Document
    end
  end
end