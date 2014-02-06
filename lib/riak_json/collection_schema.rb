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
  # Helper object for creating RiakJson schemas.
  class CollectionSchema
    attr_accessor :fields
    
    def initialize
      @fields = []
    end
    
    def add_field(field_type, field_name, required=false)
      unless self.class.valid_field_types.include? field_type.to_sym
        raise Exception, "Invalid field type"
      end
      self.fields << { name: field_name.to_s, type: field_type.to_s, require: required }
    end
    
    def add_integer_field(field_name, required=false)
      self.add_field(:integer, field_name, required)
    end

    def add_multi_string_field(field_name, required=false)
      self.add_field(:multi_string, field_name, required)
    end

    def add_string_field(field_name, required=false)
      self.add_field(:string, field_name, required)
    end
    
    def add_text_field(field_name, required=false)
      self.add_field(:text, field_name, required)
    end
    
    def build
      self.fields.to_json
    end
    
    def self.valid_field_types
      [:text, :string, :multi_string, :integer]
    end
  end
end