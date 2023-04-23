# frozen_string_literal: true

module Mutant
  class Test
    module Runner
      class Sink
        include Concord.new(:env)

        # Initialize object
        #
        # @return [undefined]
        def initialize(*)
          super
          @start        = env.world.timer.now
          @test_results = []
        end

        # Runner status
        #
        # @return [Result::Env]
        def status
          Result::Env.new(
            env:             env,
            runtime:         env.world.timer.now - @start,
            subject_results: []
          )
        end

        # Test if scheduling stopped
        #
        # @return [Boolean]
        def stop?
          @test_results.length.eql?(env.integration.all_tests.length)
        end

        # Handle mutation finish
        #
        # @return [self]
        def result(result)
          @test_results << result
          self
        end
      end # Sink
    end # Runner
  end # Test
end # Mutant
