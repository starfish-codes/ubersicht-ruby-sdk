lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ubersicht/version'

Gem::Specification.new do |spec|
  spec.name          = 'ubersicht-ruby-sdk'
  spec.version       = Ubersicht::VERSION
  spec.authors       = ['Starfish Team']
  spec.email         = ['support@starfish.codes']

  spec.summary       = %(Official Ubersicht SDK)
  spec.description   = %(Official Ubersicht SDK. Simplifies integration with Ubersicht API)
  spec.homepage      = 'https://github.com/starfish-codes/ubersicht-ruby-sdk'
  spec.license       = 'MIT'

  # spec.metadata["allowed_push_host"] = "rubygems.org"

  spec.required_ruby_version = '>= 3.0'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/starfish-codes/ubersicht-ruby-sdk/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'base64', '~> 0.1'
  spec.add_dependency 'faraday', '~> 2.0'
end
