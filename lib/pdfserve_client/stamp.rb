# frozen_string_literal: true

require_relative "version"
require "net/http"
require "uri"
require "json"

module PdfserveClient
  class Error < StandardError; end

  class Stamp
    PATH = "/api/v1/pdf/stamp"

    def initialize(api_endpoint:, api_token: nil)
      @api_endpoint = api_endpoint + PATH
      @api_token = api_token
    end

    def call(file_url, stamp_text)
      uri = URI(api_endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      request = Net::HTTP::Post.new(uri.request_uri)

      request["token"] = api_token unless api_token.nil?
      form_data = [
        ["files", file_url],
        ["stamp_text", { "text" => stamp_text, "color" => "0,0,0", "position_name" => "tr", "over" => "true" }.to_json]
      ]

      request.set_form form_data, "multipart/form-data"

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        puts "Successful stamp!"
        OpenStruct.new(
          success: true, response: response.body, errors: ""
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
