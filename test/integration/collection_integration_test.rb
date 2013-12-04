require 'helper'

describe "a RiakJson Collection" do
  context "performs read/write/delete on a Document" do
    it "issues PUT requests to insert a new document"
    it "issues POST requests to update an existing document"
    it "issues GET requests to read an existing document"
  end

  context "performs queries" do
    it "retrieves a single document with find_one()"
    it "retrieves many documents with find()"
  end
end