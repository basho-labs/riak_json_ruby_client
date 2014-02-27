## ------------------------------------------------------------------- 
## 
## Copyright (c) "2014" Basho Technologies, Inc.
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

describe "RiakJson provides geospatial Solr search" do
  # The '_rj-rb-client-us-capitals' docs were inserted in test/seeds/seeds.rb
  
  it "ensure seeding of us capitals worked" do
    client = rj_test_client
    collection = client.collection('_rj-rb-client-us-capitals')
    results = collection.all()
    results.wont_be_empty
  end
  
  it "can perform arbitrary geo Solr queries" do
    client = rj_test_client
    collection = client.collection('_rj-rb-client-us-capitals')
    spatial_field = 'capital_coords_rpt'
    location = '41.82355,-71.422132'  # Providence, RI
    distance = '300' # kilometers
    filter = true  # exclude results that are outside of the distance?
    query_params = {
      :fl => '*,score',  # field list
      :sort => 'score asc',
      :q => "{!geofilt score=distance filter=#{filter} sfield=#{spatial_field} pt=#{location} d=#{distance}}",
      :wt => 'json'
    }
    # Get a raw Solr result in JSON format back
    result = collection.solr_query_raw(query_params)
    result = JSON.parse(result)
#    puts JSON.pretty_generate(result)
    result['response']['numFound'].must_equal 6  # There should be 6 state capitals within 300km of Providence RI
  end
end