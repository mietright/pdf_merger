# PdfserveClient

PdfserveClient is a gem to merge, stamp or split PDF files using the service https://github.com/ant31/pdfserve.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdfserve_client', '~> 2.0'
```

And then execute:

```sh
bundle install
```

## Usage

### PDFServe Client

```ruby
require 'pdfserve_client'

file_urls = [
  'https://s3-public.de/file1.pdf',
  'https://s3-public.de/file2.pdf'
]
output_path = './output.pdf'

client = PdfserveClient::Client.new(api_endpoint: 'https://your.custom.endpoint')
client.merge(file_urls:, output_path:)
```

or with a token

```ruby

require 'pdfserve_client'

file_urls = [
  'https://s3-public.de/file1.pdf',
  'https://s3-public.de/file2.pdf'
]
output_path = './output.pdf'

client = PdfserveClient::Client.new(api_endpoint: 'https://your.custom.endpoint', api_token: 'the-token')
client.merge(file_urls:, output_path:)
```

`file_urls` needs to be an array of urls (images or pdfs) that need to be merged and in the order how you want to merge it
`output_path` it can be a tmp file in the machine that makes the call


### PDF Stamp

```ruby
require 'pdfserve_client'

file_url = 'https://s3-public.de/file1.pdf'
stamp_text = 'A1'

client = PdfserveClient::Client.new(api_endpoint: 'https://your.custom.endpoint')
client.stamp(file_url:, stamp_text:)
```

or with a token

```ruby

require 'pdfserve_client'

file_url = 'https://s3-public.de/file1.pdf'
stamp_text = 'A1'

client = PdfserveClient::Client.new(api_endpoint: 'https://your.custom.endpoint', api_token: 'the-token')
client.stamp(file_url:, stamp_text:)
```

`file_url` needs to be the url (image or pdf) that need to be stamped
`stamp_text` it needs to be the text you want to add at the top right of the file

### PDF Split

```ruby
require 'pdfserve_client'

file_url = 'https://s3-public.de/file1.pdf'
pages = '1-3,4,6-8'

client = PdfserveClient::Client.new(api_endpoint: 'https://your.custom.endpoint')
client.split(file_url:, pages:)
```

or with a token

```ruby

require 'pdfserve_client'

file_url = 'https://s3-public.de/file1.pdf'
pages = '1-3,4,6-8'

client = PdfserveClient::Client.new(api_endpoint: 'https://your.custom.endpoint', api_token: 'the-token')
client.split(file_url:, pages:)
```

`file_url` needs to be the url ( pdf) that need to be splitted
`pages` it needs to be comma separated page(s) range for splitting file into those pages.
