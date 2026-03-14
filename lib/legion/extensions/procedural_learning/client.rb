# frozen_string_literal: true

module Legion
  module Extensions
    module ProceduralLearning
      class Client
        include Runners::ProceduralLearning

        def initialize(engine: nil)
          @engine = engine || Helpers::LearningEngine.new
        end
      end
    end
  end
end
