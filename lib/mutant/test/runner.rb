# frozen_string_literal: true

module Mutant
  class Test
    module Runner
      # Run against env
      #
      # @return [Either<String, Result>]
      def self.call(env)
        reporter(env).start(env)

        Either::Right.new(run_tests(env))
      end

      def self.run_tests(env)
        reporter = reporter(env)

        env
          .record(:tests) { run_driver(reporter, async_driver(env)) }
          .tap { |result| env.record(:report) { reporter.report(result) } }
      end
      private_class_method :run_tests

      def self.async_driver(env)
        Parallel.async(env.world, test_config(env))
      end
      private_class_method :async_driver

      def self.run_driver(reporter, driver)
        Signal.trap('INT') do
          driver.stop
        end

        loop do
          status = driver.wait_timeout(reporter.delay)
          break status.payload if status.done?
          reporter.progress(status)
        end
      end
      private_class_method :run_driver

      def self.test_config(env)
        Parallel::Config.new(
          block:        ->(index) { run_test_index(env, index) },
          jobs:         env.config.jobs,
          process_name: 'mutant-worker-process',
          sink:         Sink.new(env),
          source:       Parallel::Source::Array.new(jobs: env.integration.all_tests.each_index.to_a),
          thread_name:  'mutant-worker-thread'
        )
      end
      private_class_method :test_config

      def self.run_test_index(env, test_index)
        env.integration.call([env.integration.all_tests.fetch(test_index)])
      end
      private_class_method :run_test_index

      def self.reporter(env)
        env.config.reporter
      end
      private_class_method :reporter

    end # Runner
  end # Test
end # Mutant
