# TagRemover

Tag remover let's you remove all elements of specified tags from extremely large XML documents without parsing or loading the whole thing in memory, useful for processing unreasonably large documents without making your server fall over.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tag_remover'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tag_remover

## Usage

The following line will read XML from `input_stream`, and write it out to `output_stream` with all `div` and `img` elements removed.

```ruby
TagRemover.process input_stream, output_stream, remove_tags: ['div', 'img']
```

Options include:

  * `remove_tags`: List of tags to remove from the XML file.
  * `close_streams`: (`true`|`false`) If set, TagRemover will close `input_stream` and `output_stream` once the proccess is over.
  * [NOT IMPLEMENTED] `format`: (`true`|`false`) If set, then the contents of `output_stream` will be formatted.

## Limitations

Tag remover currently only works correctly if the XML is formatted with only one tag per line.

## Contributing

  1. Fork it ( https://github.com/[my-github-username]/tag_remover/fork )
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request
