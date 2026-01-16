# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe Pdfserve::Split do
  let(:api_endpoint) { 'https://api.example.com' }
  let(:api_token) { 'test-token' }
  let(:split) { described_class.new(api_endpoint: api_endpoint, api_token: api_token) }

  describe '#split' do
    it 'returns success on successful split' do
      stub_request(:post, /api.example.com/).to_return(
        status: 200,
        body: 'fake tarball',
        headers: { 'Content-Disposition' => 'attachment; filename="archive.tar.gz"' }
      )
      file_url = 'https://file1.pdf'
      pages = '1-3,4,6-8'
      result = split.split(file_url: file_url, pages: pages)
      expect(result.success).to be true
      expect(result.filename).to eq('archive.tar.gz')
    end

    it 'returns failure on unsuccessful split' do
      stub_request(:post, /api.example.com/).to_return(
        status: 400,
        body: 'error',
        headers: { 'Content-Type' => 'text/plain' }
      )
      file_url = 'https://file1.pdf'
      pages = '1-3,4,6-8'
      result = split.split(file_url: file_url, pages: pages)
      expect(result.success).to be false
      expect(result.errors).to eq('Bad Request').or eq('')
    end
  end
end
