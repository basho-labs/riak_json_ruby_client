require 'virtus'

module RiakJson
  class Document
    include Virtus

    attribute :key, String
    attribute :collection, Collection
    attribute :json, Hash
  end
end