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

describe "RiakJson Ruby Client" do
  context "connects to RiakJson" do
    it "can perform an HTTP /ping to the RiakJson cluster" do
      response = rj_test_client.ping
      response.must_equal 'OK'
      response.code.must_equal 200
    end
  end
  
  context "performs document Schema administration" do
    it "issues GET requests to read a schema for an existing collection" do
      collection_name = 'test_collection'
      response = rj_test_client.get_schema(collection_name)
      response.code.must_equal 200
    end
    
    it "issues PUT requests to set a schema object for a collection" do
      collection_name = 'test_collection'
      schema_json = [{
        :name => "field_one",
        :type => "string",
        :require => true
        }, {
        :name => "field_two",
        :type => "text",
        :require => false
        }].to_json
      response = rj_test_client.set_schema_json(collection_name, schema_json)
      response.code.must_equal 204
    end
    
    it "receives a 404 Exception when reading a non-existing schema" do
      # Note: A default schema is auto-created whenever a document is written to a collection
      # For a schema to not exist, no schemas could have been stored for that collection, and no documents inserted
      collection_name = 'non-existing-collection'
      lambda { rj_test_client.get_schema(collection_name) }.must_raise RestClient::ResourceNotFound  # 404
    end
  end
end
