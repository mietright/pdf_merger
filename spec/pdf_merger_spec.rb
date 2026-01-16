RSpec.describe Pdfserve::Client do
  let(:api_endpoint) { 'https://api.example.com' }
  let(:api_token) { 'test-token' }
  let(:client) { described_class.new(api_endpoint:, api_token:) }

  it 'delegates #merge to Pdfserve::Merge' do
    merge_service = instance_double(Pdfserve::Merge)
    allow(Pdfserve::Merge).to receive(:new).and_return(merge_service)
    expect(merge_service).to receive(:merge).with(%w[a b], 'out.pdf')
    client.merge(file_urls: %w[a b], output_path: 'out.pdf')
  end

  it 'delegates #stamp to Pdfserve::Stamp' do
    stamp_service = instance_double(Pdfserve::Stamp)
    allow(Pdfserve::Stamp).to receive(:new).and_return(stamp_service)
    expect(stamp_service).to receive(:call).with('file.pdf', 'A1')
    client.stamp(file_url: 'file.pdf', stamp_text: 'A1')
  end

  it 'delegates #split to Pdfserve::Split' do
    split_service = instance_double(Pdfserve::Split)
    allow(Pdfserve::Split).to receive(:new).and_return(split_service)
    expect(split_service).to receive(:split).with(file_url: 'file.pdf', pages: '1-2')
    client.split(file_url: 'file.pdf', pages: '1-2')
  end
end
