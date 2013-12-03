# Riak Json Ruby Client

A Ruby client for [Riak Json](https://github.com/basho-labs/riak_json/)

## Installation

Since this gem is not released to the public yet, build it locally:

    git clone git@github.com:basho/riak_json_ruby_client.git
    cd riak_json_ruby_client && gem build riak_json
    gem install riak_json-0.0.2.gem

## Usage

    require 'riak_json'

    client = RiakJson::Client.new(:options => {:host => "http://localhost:8098"})
    collection = client.collection("testing")

    schema = [{
        :name => "this",
        :type => "string",
        :require => true
    }, {
        :name => "a",
        :type => "string",
        :require => false
    }].to_json

    collection.create_schema(schema)

    document = RiakJson::Document.new(
        :key => "my_key",
        :json => {
            :this => "is",
            :a => "test"
        }.to_json
    )

    collection.insert(document)

    all_results = collection.find({:this => "is"}.to_json)

    one_result = collection.find_one({:a => "test"}.to_json)

    key_result = collection.find_by_key("my_key")

    schema_result = collection.get_schema()

## Testing
```
bundle install
bundle exec rake test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
