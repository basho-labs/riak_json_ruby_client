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
    it "inserts a raw json object" do
      client = test_client
      collection_name = 'test_collection'
      collection = client.collection(collection_name)  # create a new collection object
      test_key = 'document-key-123'
      json_obj = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
      response = collection.insert_raw_json(test_key, json_obj)
      response.code.must_equal 204
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
      response = collection.update_raw_json(test_key, json_obj_modified)
      response.code.must_equal 204
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
      response = collection.delete_raw_json(test_key)
      response.code.must_equal 204
      
      # Issue a get to make sure it now returns a 404 / Resource not found exception
      lambda { collection.get_raw_json(test_key) }.must_raise RestClient::ResourceNotFound
    end
  end
  
  context "uses a RiakJson client to perform CRUD on RiakJson Documents" do
    it "inserts a new document"
    it "updates an existing document"
    it "reads an existing document"
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
    it "retrieves many documents with find()"
  end
end