require_relative 'lib/llama'

Gem::Specification.new do |spec|
  spec.name = 'llama-rb'
  spec.version = Llama::VERSION
  spec.licenses = ['MIT']
  spec.authors = ['zfletch']
  spec.email = ['zf.rubygems@gmail.com']

  spec.summary = 'Ruby interface for Llama'
  spec.description = 'ggerganov/llama.cpp with Ruby hooks'
  spec.homepage = 'https://github.com/zfletch/llama-rb'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"

  spec.files = [
    'Gemfile',
    'Gemfile.lock',
    'LICENSE',
    'README.md',
    'Rakefile',
    'bin/console',
    'ext/extconf.rb',
    'ext/Makefile',
    'lib/llama.rb',
    'lib/llama/model.rb',
    'lib/llama/version.rb',
    'llama-rb.gemspec',
    'llama.cpp/LICENSE',
    'llama.cpp/Makefile',
    'llama.cpp/README.md',
    'llama.cpp/examples/common.cpp',
    'llama.cpp/examples/common.h',
    'llama.cpp/examples/main/main.cpp',
    'llama.cpp/ggml.c',
    'llama.cpp/ggml.h',
    'llama.cpp/llama.cpp',
    'llama.cpp/llama.h',
    'models/.gitkeep',
  ]
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.extensions = %w[ext/extconf.rb]
  spec.metadata['rubygems_mfa_required'] = 'true'
end
