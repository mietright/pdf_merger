# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe Pdfserve::Stamp do
  let(:api_endpoint) { 'https://api.example.com' }
  let(:api_token) { 'test-token' }
  let(:stamp) { described_class.new(api_endpoint: api_endpoint, api_token: api_token) }

  describe '#call' do
    it 'returns success on successful stamp' do
      stub_request(:post, /api.example.com/).to_return(
        status: 200,
        body: '%PDF-1.4 stamped pdf',
        headers: { 'Content-Type' => 'application/pdf' }
      )
      file_url = 'https://file1.pdf'
      stamp_text = 'A1'
      result = stamp.call(file_url, stamp_text)
      expect(result.success).to be true
    end

    it 'returns failure on unsuccessful stamp' do
      stub_request(:post, /api.example.com/).to_return(
        status: 400,
        body: 'error',
        headers: { 'Content-Type' => 'text/plain' }
      )
      file_url = 'https://file1.pdf'
      stamp_text = 'A1'
      result = stamp.call(file_url, stamp_text)
      expect(result.success).to be false
      expect(result.errors).to eq('Bad Request').or eq("")
    end
  end
end
