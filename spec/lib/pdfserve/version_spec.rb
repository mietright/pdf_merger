# frozen_string_literal: true

RSpec.describe Pdfserve do
  it 'has a version number' do
    expect(Pdfserve::VERSION).not_to be nil
    expect(Pdfserve::VERSION).to match(/\A\d+\.\d+\.\d+/)
  end
end
