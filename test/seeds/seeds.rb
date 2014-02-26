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

require 'riak_json'

# Create a client pointed to test instance
host = ENV['RIAK_HOST'] ? ENV['RIAK_HOST'] : RiakJson::RIAK_TEST_HOST
port = ENV['RIAK_PORT'] ? ENV['RIAK_PORT'] : RiakJson::RIAK_TEST_PORT
client = RiakJson::Client.new(host, port)

# Ensure a collection has an existing schema for the Delete Schema test
collection = client.collection('_rj-rb-client-cities-delete-schema')
schema = RiakJson::CollectionSchema.new
schema.add_text_field(name='city', required=true)
collection.set_schema(schema)

# Set up the US States/Capitals collection, to test the geo search functionality
schema = RiakJson::CollectionSchema.new
schema.add_string_field('abbreviation', required=true)
schema.add_text_field('name', true)
schema.add_text_field('capital', true)
schema.add_location_rpt_field('capital_coords_rpt')

capitals = client.collection('_rj-rb-client-us-capitals')
capitals.set_schema(schema)

us_capitals_json = File.open('test/seeds/us_capitals.json', 'rb') { |file| file.read }
us_capitals = JSON.parse(us_capitals_json)

us_capitals.each do | abbrev, state_data |
  state_json = {
    :abbreviation => abbrev,
    :name => state_data['name'],
    :capital => state_data['capital'],
    :capital_coords_rpt => "#{state_data['lat']},#{state_data['lon']}"
  }
  state_doc = RiakJson::Document.new(abbrev, state_json)
  capitals.insert(state_doc)
end