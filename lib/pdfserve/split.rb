# frozen_string_literal: true

require_relative "version"
require "net/http"
require "uri"
require "json"
require "ostruct"

module Pdfserve
  class Error < StandardError; end

  class Split
    PATH = "/api/v1/pdf/split"

    def initialize(api_endpoint:, api_token: nil)
      @api_endpoint = api_endpoint + PATH
      @api_token = api_token
    end

    def split(file_url:, pages:)
      uri = URI(api_endpoint)
      uri.query = URI.encode_www_form({ pages: pages })

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      request = Net::HTTP::Post.new(uri.request_uri)

      request["token"] = api_token unless api_token.nil?
      form_data = [["splitfile", file_url]]

      request.set_form form_data, "multipart/form-data"

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        puts "Successful split!"
        content_disposition = response.header["Content-Disposition"]
        filename = content_disposition[/filename="?([^"]+)"?/, 1] || "archive.tar.gz"

        OpenStruct.new(
          success: true, response: response.read_body, filename: filename, errors: ""
        )
      else
        puts "Failed!"
        OpenStruct.new(
          success: false, response: response.body, errors: response.message
        )
      end
    end

    private

    attr_reader :api_endpoint, :api_token
  end
end
