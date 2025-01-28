require_relative "pdfserve_client/merge"
require_relative "pdfserve_client/stamp"
require_relative "pdfserve_client/split"

module PdfserveClient
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
      PdfserveClient::Merge.new(api_endpoint: @api_endpoint, api_token: @api_token)
    end

    def stamp_service
      PdfserveClient::Stamp.new(api_endpoint: @api_endpoint, api_token: @api_token)
    end

    def split_service
      PdfserveClient::Split.new(api_endpoint: @api_endpoint, api_token: @api_token)
    end
  end
end
