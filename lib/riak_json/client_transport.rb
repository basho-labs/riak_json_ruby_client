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

require 'rest-client'

module RiakJson
  # Used by RiakJson::Client to make HTTP requests
  class ClientTransport
    def get_request(url)
      self.send_request(url, :get)
    end
    
    def send_request(url, http_method, data=nil)
      begin
        case http_method
          when :get
          response = RestClient.get url, {:content_type => :json}
          when :put
            response = RestClient.put url, data, {:content_type => :json, :accept => :json}
          when :post
            response = RestClient.post url, data, {:content_type => :json, :accept => :json}
          when :delete
            response = RestClient.delete url
          else
            raise ArgumentError, "Invalid HTTP :method - #{http_method}"
        end
      rescue Exception => e
        puts e.inspect
      end
      response
    end
  end
end