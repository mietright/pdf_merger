# frozen_string_literal: true

require_relative "version"
require "net/http"
require "uri"
require "json"

module PdfserveClient
  class Error < StandardError; end

  class Merge
    PATH = "/api/v1/pdf/merge"

    def initialize(api_endpoint:, api_token: nil)
      @api_endpoint = api_endpoint + PATH
      @api_token = api_token
    end

    def merge(file_urls, output_path)
      uri = URI(api_endpoint)
      request = Net::HTTP::Post.new(uri)
      request["token"] = api_token unless api_token.nil?
      form_data = file_urls.map { |url| ["files", url] }

      request.set_form form_data, "multipart/form-data"

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      if response.is_a?(Net::HTTPSuccess)
        File.open(output_path, "wb") { |file| file.write(response.body) }
        puts "Success!"
        OpenStruct.new(success: true, errors: "")
      else
        puts "Failed!"
        OpenStruct.new(success: false, errors: response.message)
      end
    end

    private

    attr_reader :api_endpoint, :api_token
  end
end
