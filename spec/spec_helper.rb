require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/spec/"
end


require_relative '../lib/pdfserve/client'
require_relative '../lib/pdfserve/merge'
require_relative '../lib/pdfserve/split'
require_relative '../lib/pdfserve/stamp'
require_relative '../lib/pdfserve/version'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
