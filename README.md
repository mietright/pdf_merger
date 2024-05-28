# PdfMerger

PdfMerger is a gem to merge PDF files using the merger conny.dev service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdf_merger', git: 'https://github.com/mietright/pdf_merger'
```

And then execute:

```sh
bundle install
```

## Usage

```ruby
require 'pdf_merger'

file_urls = [
  'https://s3-public.de/file1.pdf',
  'https://s3-public.de/file2.pdf'
]
output_path = './output.pdf'

merger = PdfMerger::Merger.new(file_urls, output_path, skip_token: true, api_endpoint: 'https://your.custom.endpoint/api/v1/pdf/merge')
merger.merge
```

or with a token

```ruby

require 'pdf_merger'

file_urls = [
  'https://s3-public.de/file1.pdf',
  'https://s3-public.de/file2.pdf'
]
output_path = './output.pdf'

merger = PdfMerger::Merger.new(file_urls, output_path, skip_token: false, api_endpoint: 'https://your.custom.endpoint/api/v1/pdf/merge', api_token: 'the-token')
merger.merge
```
