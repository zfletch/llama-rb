require_relative 'lib/llama'

Gem::Specification.new do |spec|
  spec.name = 'llama-rb'
  spec.version = Llama::VERSION
  spec.licenses = ['MIT']
  spec.authors = ['zfletch']
  spec.email = ['zfletch2@gmail.com']

  spec.summary = 'Ruby interface for Llama'
  spec.description = 'ggerganov/llama.cpp with Ruby hooks'
  spec.homepage = 'https://github.com/zfletch/llama-rb'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = [
    'Gemfile',
    'Gemfile.lock',
    'LICENSE',
    'README.md',
    'Rakefile',
    'ext/llama/common.cpp',
    'ext/llama/common.h',
    'ext/llama/extconf.rb',
    'ext/llama/ggml.c',
    'ext/llama/ggml.h',
    'ext/llama/llama.cpp',
    'ext/llama/llama.h',
    'ext/llama/model.cpp',
    'lib/llama.rb',
    'lib/llama/model.rb',
    'lib/llama/version.rb',
    'llama-rb.gemspec',
    'llama.cpp',
    'models/.gitkeep',
  ]
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rice', '~> 4.0.4'

  spec.extensions = %w[ext/llama/extconf.rb]
  spec.metadata['rubygems_mfa_required'] = 'true'
end
