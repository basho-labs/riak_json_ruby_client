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
  class Document
    attr_accessor :key
    attr_accessor :body
    
    def initialize(key=nil, body={})
      @key = key
      @body = body
    end
    
    def [](key)
      @body[key]
    end
    
    def []=(key, value)
      @body[key] = value
    end
    
    # Returns a JSON string representation
    def to_json
      self.body.to_json
    end
    
    # Returns a JSON string representation.
    # Invoked by RiakJson::Collection to serialize
    # an object for writing to RiakJson
    def to_json_document
      self.to_json
    end
  end
end