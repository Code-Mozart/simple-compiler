# frozen_string_literal: true

require 'yaml'

module Simplec
  module Backends
    class ASTFormatter
      include Simplec::Backends::FileOutput
      default_output_format :yml
      default_output_suffix 'ast'

      def initialize
        @output_format = :yml
      end

      def run(ast_root)
        output_file = File.new output_file_path
        output_file.content = Helpers.stringify_keys(ast_root.to_h).to_yaml
        output_file.write
        ast_root
      end
    end
  end
end
