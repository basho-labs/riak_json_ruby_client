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

describe "a RiakJson Client" do
  context "when created" do
    it "has an empty collection cache" do
      rj_test_client.collection_cache.must_be_empty
    end
    
    it "has a riak host and port" do
      client = rj_test_client
      client.host.must_equal @rj_client.host
      client.port.must_equal @rj_client.port
    end
    
    it "initializes a transport object" do
      client = rj_test_client
      client.transport.must_be_kind_of RiakJson::ClientTransport
    end
  end

  context "knows the URLs to Riak and RiakJSON API endpoints" do
    it "knows riak cluster and riakjson urls" do
      client = rj_test_client
      client.base_riak_url.wont_be_empty
      client.base_riak_json_url.wont_be_empty
    end
    it "knows riakjson collection url" do
      client = rj_test_client
      client.base_collection_url.wont_be_empty
    end
  end
  
  it "uses its collection cache when instantiating collections" do
    client = rj_test_client
    collection1 = client.collection('test_collection')
    collection2 = client.collection('test_collection')
    collection1.must_be_same_as collection2, "Client uses collection cache, collection1 and collection2 should be identical"
  end
  
  it "reads JSON objects from collections" do
    client = rj_test_client
    collection_name = 'test_collection'
    test_key = 'document-key-123'
    client.transport = MiniTest::Mock.new
    
    # Test that a client.get_json_object call results in an HTTP GET request to /collection_name/key
    client.transport.expect :send_request, nil, ["#{client.base_collection_url}/#{collection_name}/document-key-123", :get]
    client.get_json_object(collection_name, test_key)
    client.transport.verify
  end
  
  it "writes a new JSON object to a collection with a specified key" do
    client = rj_test_client
    collection_name = 'test_collection'
    test_key = 'document-key-123'
    test_json = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
    client.transport = MiniTest::Mock.new
    
    # Test that a client.insert_json_object call results in an HTTP PUT request to /collection_name/key
    client.transport.expect :send_request, nil, ["#{client.base_collection_url}/#{collection_name}/document-key-123", :put, test_json]
    client.insert_json_object(collection_name, test_key, test_json)
    client.transport.verify
  end
  
  it "updates an existing JSON object in a collection" do
    client = rj_test_client
    collection_name = 'test_collection'
    test_key = 'document-key-123'
    test_json = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
    client.transport = MiniTest::Mock.new
    
    # Test that a client.update_json_object call results in an HTTP PUT request to /collection_name/key
    client.transport.expect :send_request, nil, ["#{client.base_collection_url}/#{collection_name}/document-key-123", :put, test_json]
    client.update_json_object(collection_name, test_key, test_json)
    client.transport.verify
  end

  it "raises an exception if updating a JSON object with no key" do
    client = rj_test_client
    collection_name = 'test_collection'
    nil_key = nil
    test_json = { 'field_one' => '123', 'field_two' => 'abc' }.to_json
    
    lambda { client.update_json_object(collection_name, nil, test_json) }.must_raise Exception
  end
  
  it "deletes an existing JSON object in a collection" do
    client = rj_test_client
    collection_name = 'test_collection'
    test_key = 'document-key-123'
    client.transport = MiniTest::Mock.new
    
    # Test that a client.delete_json_object call results in an HTTP DELETE request to /collection_name/key
    client.transport.expect :send_request, nil, ["#{client.base_collection_url}/#{collection_name}/document-key-123", :delete]
    client.delete_json_object(collection_name, test_key)
    client.transport.verify
  end
  
  context "performs document Schema administration" do
    it "sets a schema json object into a collection's schema api endpoint" do
      client = rj_test_client
      collection_name = 'test_collection'
      client.transport = MiniTest::Mock.new
      schema_json = [{
        :name => "field_one",
        :type => "string",
        :require => true
        }, {
        :name => "field_two",
        :type => "text",
        :require => false
        }].to_json
      
      client.transport.expect :send_request, nil, ["#{client.base_collection_url}/#{collection_name}/schema", :put, schema_json]
      client.set_schema_json(collection_name, schema_json)
      client.transport.verify
    end
  end
  
  context "sends JSON queries to retrieve documents" do
    it "sends requests to /query/one" do
      client = rj_test_client
      collection_name = 'test_collection'
      client.transport = MiniTest::Mock.new
      query_json = {:company_name => 'Basho Technologies'}.to_json
      
      client.transport.expect :send_request, nil, ["#{client.base_collection_url}/#{collection_name}/query/one", :put, query_json]
      client.get_query_one(collection_name, query_json)
      client.transport.verify
    end
    
    it "sends requests to /query/all" do
      client = rj_test_client
      collection_name = 'cities'
      client.transport = MiniTest::Mock.new
      query_json = {:country => 'USA'}.to_json
      
      client.transport.expect :send_request, nil, ["#{client.base_collection_url}/#{collection_name}/query/all", :put, query_json]
      client.get_query_all(collection_name, query_json)
      client.transport.verify
    end
  end
end
