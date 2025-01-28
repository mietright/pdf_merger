# pdf_merger.gemspec
Gem::Specification.new do |spec|
  spec.name          = "pdfserve_client"
  spec.version       = "2.0.0"
  spec.authors       = ["Isabel Garcia", "Antoine Legrand", "Lakhan Pasari"]
  spec.email         = ["isabel.garcia@conny.legal", "antoine.legrand@conny.legal", "lakhan.pasari@conny.legal"]

  spec.summary       = "A gem for merging, stamping, and splitting PDFs using an external API"
  spec.description   = "This gem provides a simple interface to merge, stamp, split PDFs using https://github.com/ant31/pdfserve API."
  spec.homepage      = "https://github.com/mietright/pdf_merger"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "net-http", "~> 0.2.0"
end
