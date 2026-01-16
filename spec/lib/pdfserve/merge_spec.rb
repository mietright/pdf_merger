# frozen_string_literal: true

require 'webmock/rspec'
require 'fileutils'

RSpec.describe Pdfserve::Merge do
  let(:api_endpoint) { 'https://api.example.com' }
  let(:api_token) { 'test-token' }
  let(:merge) { described_class.new(api_endpoint: api_endpoint, api_token: api_token) }

  describe '#merge' do
    it 'returns success on successful merge' do
      stub_request(:post, /api.example.com/).to_return(
        status: 200,
        body: '%PDF-1.4 fake pdf',
        headers: { 'Content-Type' => 'application/pdf' }
      )
      file_urls = ['https://file1.pdf', 'https://file2.pdf']
      output_path = 'tmp/test_output.pdf'
      FileUtils.mkdir_p(File.dirname(output_path))
      result = merge.merge(file_urls, output_path)
      expect(result.success).to be true
      expect(File.exist?(output_path)).to be true
      File.delete(output_path)
    end

    it 'returns failure on unsuccessful merge' do
      stub_request(:post, /api.example.com/).to_return(
        status: 400,
        body: 'error',
        headers: { 'Content-Type' => 'text/plain' }
      )
      file_urls = ['https://file1.pdf', 'https://file2.pdf']
      output_path = 'tmp/test_output.pdf'
      FileUtils.mkdir_p(File.dirname(output_path))
      result = merge.merge(file_urls, output_path)
      expect(result.success).to be false
      expect(result.errors).to eq('Bad Request').or eq('')
      expect(File.exist?(output_path)).to be false
    end
  end
end
