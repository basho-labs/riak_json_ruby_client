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
  it "can load configuration from a file" do
    test_config_path = 'test/examples/riak.yml'
    config_hash = RiakJson::Client.load_config_file(test_config_path)
    assert config_hash.include?('development'), "Sample config file should have a 'development' environment section"
    dev_config = config_hash['development']
    dev_config['http_port'].wont_be_nil
    dev_config['host'].wont_be_nil
    # The loaded config hash can then be used to set up the client
    client = RiakJson::Client.new(dev_config['host'], dev_config['http_port'])
  end
  
  context "connects to RiakJson" do
    it "can perform an HTTP /ping to the RiakJson cluster" do
      response = rj_test_client.ping
      response.must_equal 'OK'
      response.code.must_equal 200
    end
  end
  
  context "performs document Schema administration" do
    it "receives a 404 Exception when reading a non-existing schema" do
      # Note: A default schema is auto-created whenever a document is written to a collection
      # For a schema to not exist, no schemas could have been stored for that collection, and no documents inserted
      collection_name = 'non-existing-collection'
      lambda { rj_test_client.get_schema(collection_name) }.must_raise RestClient::ResourceNotFound  # 404
    end
  end
  
  it "can list all collections in the cluster" do
    result = rj_test_client.collections()
    result.wont_be_empty
    result.first.must_be_kind_of RiakJson::Collection
  end
end
