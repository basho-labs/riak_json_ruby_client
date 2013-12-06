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
  
  it "implements hash style getters and setters for its body" do
    test_key = 'key-123'
    test_body = { :field_one => '123', :field_two => 'abc' }
    doc = RiakJson::Document.new(test_key, test_body)
    
    doc[:field_one].must_equal '123'
      
    doc[:field_two] = 'xyz'
    doc.body[:field_two].must_equal 'xyz'
  end
end