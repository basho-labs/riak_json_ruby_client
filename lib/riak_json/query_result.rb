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

module RiakJson
  # QueryResult is a helper object that
  # holds the results of a collection.find_all query
  class QueryResult
    attr_reader :documents
    attr_reader :num_pages
    attr_reader :page
    attr_reader :per_page
    attr_reader :total
    
    def initialize(response)
      if response.nil? or response.empty?
        result_hash = {}
      else
        result_hash = JSON.parse(response)
        if result_hash.kind_of? Array and result_hash.empty?
          result_hash = {}
        end
      end
      
      @num_pages = result_hash.fetch('num_pages', 0)
      @page = result_hash.fetch('page', 0)
      @total = result_hash.fetch('total', 0)
      @per_page = result_hash.fetch('per_page', 0)
      
      documents = result_hash.fetch('data', [])
      @documents = documents.map { | body | RiakJson::Document.new(body['_id'], body) }
    end
    
    # Return true if no results came back for a query
    # @return [Boolean]
    def empty?
      self.total == 0
    end
  end
end