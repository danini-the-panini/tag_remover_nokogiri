# TagRemover (Nokogiri edition)

Tag remover let's you remove all elements of specified tags from extremely large XML documents without parsing or loading the whole thing in memory, useful for processing unreasonably large documents without making your server fall over.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tag_remover_nokogiri'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tag_remover_nokogiri

## Usage

The following code will read XML from `input_stream`, and write it out to `output_stream` with all `div` and `img` elements removed.

```ruby
require 'tag_remover'

TagRemover.process input_stream, output_stream, remove_tags: ['div', 'img']
```

Options include:

  * `remove_tags`: List of tags to remove from the XML file.
  * `close_streams`: (`true`|`false`) If set, TagRemover will close `input_stream` and `output_stream` once the proccess is over.
  * [NOT IMPLEMENTED] `format`: (`true`|`false`) If set, then the contents of `output_stream` will be formatted.

TagRemover can be used from the command line with the `rmtags` command. The following is an example that reads input.xml and writes the output to output.xml, removing all `div` and `img` elements:

    $ rmtags input.xml output.xml div img

## Contributing

  1. Fork it ( https://github.com/[my-github-username]/tag_remover_nokogiri/fork )
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request
