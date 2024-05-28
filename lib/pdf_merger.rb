# frozen_string_literal: true

require_relative "pdf_merger/version"
require 'net/http'
require 'uri'
require 'json'

module PdfMerger
  class Error < StandardError; end

  class Merger
    def initialize(file_urls, output_path, skip_token: false, api_endpoint:, api_token: nil)
      @file_urls = file_urls
      @output_path = output_path
      @skip_token = skip_token
      @api_endpoint = api_endpoint
      @api_token = api_token
    end

    def merge
      uri = URI(api_endpoint)
      request = Net::HTTP::Post.new(uri)
      request['token'] = api_token unless skip_token
      form_data = file_urls.map { |url| ["files", url] }
      
      request.set_form form_data, 'multipart/form-data'
      
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      if response.is_a?(Net::HTTPSuccess)
        File.open(output_path, 'wb') { |file| file.write(response.body) }
        puts "Success!"
        OpenStruct.new(success: true, errors: '')
      else
        puts "Failed!"
        OpenStruct.new(success: false, errors: response.message)
      end
    end

    private

    attr_reader :file_urls, :output_path,
                :skip_token, :api_endpoint, :api_token
  end
end
