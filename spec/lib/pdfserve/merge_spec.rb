# frozen_string_literal: true

require 'webmock/rspec'
require 'fileutils'

RSpec.describe Pdfserve::Merge do
  let(:api_endpoint) { 'https://api.example.com' }
  let(:api_token) { 'test-token' }
  let(:merge) { described_class.new(api_endpoint:, api_token:) }

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

    it 'sends rotations as repeated query params aligned with files' do
      stub = stub_request(:post, 'https://api.example.com/api/v1/pdf/merge?rotations=90&rotations=0').to_return(
        status: 200,
        body: '%PDF-1.4 fake pdf',
        headers: { 'Content-Type' => 'application/pdf' }
      )
      output_path = 'tmp/test_output.pdf'
      FileUtils.mkdir_p(File.dirname(output_path))
      result = merge.merge(['https://file1.pdf', 'https://file2.pdf'], output_path, rotations: [90, 0])
      expect(result.success).to be true
      expect(stub).to have_been_requested
      File.delete(output_path)
    end

    it 'does not add a query string when rotations are omitted' do
      stub = stub_request(:post, 'https://api.example.com/api/v1/pdf/merge').to_return(
        status: 200,
        body: '%PDF-1.4 fake pdf',
        headers: { 'Content-Type' => 'application/pdf' }
      )
      output_path = 'tmp/test_output.pdf'
      FileUtils.mkdir_p(File.dirname(output_path))
      result = merge.merge(['https://file1.pdf', 'https://file2.pdf'], output_path)
      expect(result.success).to be true
      expect(stub).to have_been_requested
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
