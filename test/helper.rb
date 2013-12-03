require 'minitest/autorun'
require 'minitest-spec-context'
require 'riak_json'

def test_client
  RiakJson::Client.new
end