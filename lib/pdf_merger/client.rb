require_relative "merger"
require_relative "stamp"
require_relative "split"

module PdfMerger
  class Client
    attr_reader :merge_service, :stamp_service, :split_service

    def initialize(api_endpoint:, api_token:)
      @api_endpoint = api_endpoint
      @api_token = api_token
    end

    def merge(file_urls:, output_path:)
      merge_service.merge(file_urls, output_path)
    end

    def stamp(file_url:, stamp_text:)
      stamp_service.call(file_url, stamp_text)
    end

    def split(file_url:, pages:)
      split_service.split(file_url:, pages:)
    end

    private

    def merge_service
      PdfMerger::Merge.new(api_endpoint: @api_endpoint, api_token: @api_token)
    end

    def stamp_service
      PdfMerger::Stamp.new(api_endpoint: @api_endpoint, api_token: @api_token)
    end

    def split_service
      PdfMerger::Split.new(api_endpoint: @api_endpoint, api_token: @api_token)
    end
  end
end
