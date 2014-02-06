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

describe "a RiakJson Collection Schema" do
  context "builds a schema definition by adding fields" do
    it "initializes to an empty fields list" do
      schema = RiakJson::CollectionSchema.new
      schema.fields.must_be_empty
      schema.fields.count.must_equal 0
    end
    
    it "can add field definitions with type passed in" do
      schema = RiakJson::CollectionSchema.new
      schema.add_field(:text, :city, true)
      schema.fields.count.must_equal 1
      schema.fields[0][:name].must_equal 'city'
      schema.fields[0][:type].must_equal 'text'
      schema.fields[0][:require].must_equal true
    end
    
    it "can add a text field to the schema definition" do
      # schema = [{
      #    :name => "city",
      #    :type => "text",
      #    :require => true
      # }]
      schema = RiakJson::CollectionSchema.new
      schema.add_text_field(name='city', required=true)
      schema.fields.count.must_equal 1
      schema.fields[0][:name].must_equal 'city'
      schema.fields[0][:type].must_equal 'text'
      schema.fields[0][:require].must_equal true
    end
    
    it "can add a string field to the schema definition" do
      # schema = [{
      #    :name => "state",
      #    :type => "string",
      #    :require => false
      # }]
      schema = RiakJson::CollectionSchema.new
      schema.add_string_field(name='state')  # required: false by default
      schema.fields.count.must_equal 1
      schema.fields[0][:name].must_equal 'state'
      schema.fields[0][:type].must_equal 'string'
      schema.fields[0][:require].must_equal false
    end
    
    it "can add a multi_string field to the schema definition" do
      # schema = [{
      #    :name => "zip_codes",
      #    :type => "multi_string",
      #    :require => true
      # }]
      schema = RiakJson::CollectionSchema.new
      schema.add_multi_string_field(name='zip_codes', required=true)
      schema.fields.count.must_equal 1
      schema.fields[0][:name].must_equal 'zip_codes'
      schema.fields[0][:type].must_equal 'multi_string'
      schema.fields[0][:require].must_equal true
    end

    it "can add an integer field to the schema definition" do
      # schema = [{
      #    :name => "population",
      #    :type => "integer",
      #    :require => false
      # }]
      schema = RiakJson::CollectionSchema.new
      schema.add_integer_field(name='population', required=false)
      schema.fields.count.must_equal 1
      schema.fields[0][:name].must_equal 'population'
      schema.fields[0][:type].must_equal 'integer'
      schema.fields[0][:require].must_equal false
    end
    
    it "builds a json object representation" do
      schema = RiakJson::CollectionSchema.new
      schema.add_text_field(name='city', required=true)
      schema.add_string_field(name='state')
      
      # This can be stored via collection.set_schema
      schema_json = schema.build
      
      fields_array = JSON.parse(schema_json)
      fields_array.count.must_equal 2
      fields_array[0]['name'].must_equal 'city'
    end
  end
end