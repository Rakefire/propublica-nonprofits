lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "propublica/nonprofits/version"

Gem::Specification.new do |spec|
  spec.name = "propublica-nonprofits"
  spec.version = Propublica::Nonprofits::VERSION
  spec.authors = ["Ricky Chilcott"]
  spec.email = ["ricky@rakefire.io"]

  spec.summary = %q{Ruby wrapper for the Propublica Nonprofits API https://projects.propublica.org/nonprofits/api/v2}
  spec.description = %q{Ruby wrapper for the Propublica Nonprofits API https://projects.propublica.org/nonprofits/api/v2}
  spec.homepage = "https://github.com/Rakefire/propublica-nonprofits"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "minitest-line"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "faraday"
  spec.add_dependency "json"
end
