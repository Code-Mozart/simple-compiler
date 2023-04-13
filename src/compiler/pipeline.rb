# frozen_string_literal: true

module Simplec
  class Compiler
    class Pipeline
      def initialize(file, output_path_base)
        @stages = []
        @file = file
        @output_path_base = output_path_base
      end

      def <<(stage)
        check_if_pipeline_stage stage
        stage.source_file = @file if stage.respond_to? :source_file=
        stage.output_path_base = @output_path_base if stage.respond_to? :output_path_base=
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
      end
    end
  end
end
