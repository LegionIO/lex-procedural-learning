# frozen_string_literal: true

require_relative 'lib/legion/extensions/procedural_learning/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-procedural-learning'
  spec.version       = Legion::Extensions::ProceduralLearning::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Procedural Learning'
  spec.description   = "Anderson's ACT-R production rules — skill acquisition from declarative " \
                       'to autonomous for brain-modeled agentic AI'
  spec.homepage      = 'https://github.com/LegionIO/lex-procedural-learning'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']        = spec.homepage
  spec.metadata['source_code_uri']     = 'https://github.com/LegionIO/lex-procedural-learning'
  spec.metadata['documentation_uri']   = 'https://github.com/LegionIO/lex-procedural-learning'
  spec.metadata['changelog_uri']       = 'https://github.com/LegionIO/lex-procedural-learning'
  spec.metadata['bug_tracker_uri']     = 'https://github.com/LegionIO/lex-procedural-learning/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-procedural-learning.gemspec Gemfile]
  end
  spec.require_paths = ['lib']
end
