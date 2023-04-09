# frozen_string_literal: true

module Simplec
  class Compiler
    class Pipeline
      def initialize(file)
        @stages = []
        @file = file
      end

      def <<(stage)
        check_if_pipeline_stage stage
        stage.instance_variable_set :@file, @file
        stage.refresh_parameters
        @stages << stage
      end

      def run
        @data = @file.content
        @stages.each do |stage|
          @data = stage.run @data
        end
        @data
      end

      private

      def check_if_pipeline_stage(stage)
        raise ArgumentError, "pipeline stage #{stage} must respond to #run" unless stage.respond_to? :run
        unless stage.method(:run).arity.abs >= 1
          raise ArgumentError, '#run must accept the intermediate result as argument'
        end

        unless stage.respond_to? :refresh_parameters
          raise ArgumentError, "pipeline stage #{stage} must respond to #refresh_parameters"
        end
      end
    end
  end
end
