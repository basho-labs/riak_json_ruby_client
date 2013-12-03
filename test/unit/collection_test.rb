require 'helper'

describe "a RiakJson Collection" do
  context "when created" do
    it "requires a name" do
      client = test_client  # in helper.rb
      lambda { client.collection() }.must_raise ArgumentError
    end
  end
  
  it "is initialized" do
    col = RiakJson::Collection.new
  end
end