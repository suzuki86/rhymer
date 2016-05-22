# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rhymer/version'

Gem::Specification.new do |spec|
  spec.name          = "rhymer"
  spec.version       = Rhymer::VERSION
  spec.authors       = ["suzuki86"]
  spec.email         = ["tsnr0001@gmail.com"]

  spec.summary       = %q{Find rhyme from text.}
  spec.description   = %q{Find rhyme from text.}
  spec.homepage      = "https://github.com/suzuki86/rhymer"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "natto", "~> 1.1.0"
end
