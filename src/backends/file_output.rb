# frozen_string_literal: true

module Simplec
  module Backends
    module FileOutput
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def default_output_format(format)
          @default_output_format = format
        end

        def default_output_suffix(suffix)
          @default_output_suffix = suffix
        end
      end

      def output_path_base=(base_path)
        @output_file_path = String.new base_path
        @output_file_path << ".#{output_suffix}" if output_suffix
        @output_file_path << ".#{output_format}" if output_format
      end

      def output_file_path
        @output_file_path ||= "#{Simplec.root}/output_file.txt"
      end

      def output_format
        @output_format ||= self.class.instance_variable_get(:@default_output_format)
      end

      def output_suffix
        @output_suffix ||= self.class.instance_variable_get(:@default_output_suffix)
      end
    end
  end
end
