# frozen_string_literal: true

require 'legion/extensions/procedural_learning/version'
require 'legion/extensions/procedural_learning/helpers/constants'
require 'legion/extensions/procedural_learning/helpers/production'
require 'legion/extensions/procedural_learning/helpers/skill'
require 'legion/extensions/procedural_learning/helpers/learning_engine'
require 'legion/extensions/procedural_learning/runners/procedural_learning'
require 'legion/extensions/procedural_learning/client'

module Legion
  module Extensions
    module ProceduralLearning
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
