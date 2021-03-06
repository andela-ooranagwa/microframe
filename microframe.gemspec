# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "microframe/version"

Gem::Specification.new do |spec|
  spec.name          = "microframe"
  spec.version       = Microframe::VERSION
  spec.authors       = ["Osmond"]
  spec.email         = ["osmond.oranagwa@andela.com"]

  spec.summary       = %q{A Microframe for building web apps}
  spec.homepage      = "https://github.com/andela-ooranagwa/microframe"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting "allowed_push_host", or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = %w{microframe}
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack", "~> 1.6", ">= 1.6.4"
  spec.add_runtime_dependency "bundler"
  spec.add_runtime_dependency "thor", "~> 0.19.1"
  spec.add_runtime_dependency "sqlite3", "~> 1.3", ">= 1.3.11"
  spec.add_runtime_dependency "tilt", "~> 2.0", ">= 2.0.1"

  spec.add_development_dependency "pry-nav", "~> 0.2.4"
  spec.add_development_dependency "rake", "~> 10.4", ">= 10.4.2"
  spec.add_development_dependency "minitest", "~> 5.8", ">= 5.8.3"
  spec.add_development_dependency "capybara", "~> 2.5", ">= 2.5.0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4", ">= 0.4.8"
  spec.add_development_dependency "simplecov", "~> 0.10", ">= 0.10.0"
  spec.add_development_dependency "rubocop"
end
