# frozen_string_literal: true

require_relative "pdf_merger/version"
require 'net/http'
require 'uri'
require 'json'

module PdfMerger
  class Error < StandardError; end

  class Stamp
    def initialize(api_endpoint:, api_token: nil)
      @api_endpoint = api_endpoint
      @api_token = api_token
    end

    def call(file_url, stamp_text)
      uri = URI(api_endpoint)
      request = Net::HTTP::Post.new(uri)
      request['token'] = api_token unless api_token.nil?
      form_data = [
        ["files", file_url],
        ["stamp_text", {"text": stamp_text, "color": "0,0,0", "position_name": "tr"}]
      ]
      
      request.set_form form_data, 'multipart/form-data'
      
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      if response.is_a?(Net::HTTPSuccess)
        puts "Successfull stamp!"
        OpenStruct.new(
          success: true, response: response.body, errors: ''
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
