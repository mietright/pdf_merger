# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe Pdfserve::Client do
  let(:api_endpoint) { 'https://api.example.com' }
  let(:api_token) { 'test-token' }
  let(:client) { described_class.new(api_endpoint: api_endpoint, api_token: api_token) }

  it 'initializes with api_endpoint and api_token' do
    expect(client).to be_a(Pdfserve::Client)
  end

  describe '#merge' do
    it 'delegates to merge_service' do
      merge_service = instance_double(Pdfserve::Merge)
      allow(Pdfserve::Merge).to receive(:new).and_return(merge_service)
      expect(merge_service).to receive(:merge).with(['a', 'b'], 'out.pdf')
      client.merge(file_urls: ['a', 'b'], output_path: 'out.pdf')
    end
  end

  describe '#stamp' do
    it 'delegates to stamp_service' do
      stamp_service = instance_double(Pdfserve::Stamp)
      allow(Pdfserve::Stamp).to receive(:new).and_return(stamp_service)
      expect(stamp_service).to receive(:call).with('file.pdf', 'A1')
      client.stamp(file_url: 'file.pdf', stamp_text: 'A1')
    end
  end

  describe '#split' do
    it 'delegates to split_service' do
      split_service = instance_double(Pdfserve::Split)
      allow(Pdfserve::Split).to receive(:new).and_return(split_service)
      expect(split_service).to receive(:split).with(file_url: 'file.pdf', pages: '1-2')
      client.split(file_url: 'file.pdf', pages: '1-2')
    end
  end
end
