# frozen_string_literal: true

require_relative "pdf_merger/version"
require 'net/http'
require 'uri'
require 'json'

module PdfMerger
  class Error < StandardError; end

  class Merger
    API_ENDPOINT = ENV.fetch('PDF_MERGER_API_ENDPOINT', nil)
    API_TOKEN = ENV.fetch('PDF_MERGER_TOKEN', nil)

    def initialize(file_urls, output_path)
      @file_urls = file_urls
      @output_path = output_path
    end

    def merge
      uri = URI(API_ENDPOINT)
      request = Net::HTTP::Post.new(uri)
      request['token'] = API_TOKEN
      form_data = @file_urls.map { |url| ["files", url] }
      
      request.set_form form_data, 'multipart/form-data'
      
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      if response.is_a?(Net::HTTPSuccess)
        File.open(@output_path, 'wb') { |file| file.write(response.body) }
        puts "PDF merged successfully and saved to #{@output_path}"
      else
        puts "Failed to merge PDF: #{response.message}"
      end
    end
  end
end
