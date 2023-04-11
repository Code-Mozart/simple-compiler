# frozen_string_literal: true

require 'yaml'

module Simplec
  module Backends
    class ASTFormatter
      def initialize
      end

      def refresh_parameters
        @output_format = :yml
        @output_file_path = "#{Simplec.root}/#{@file.filename}.ast.#{@output_format}"
      end

      def run(ast_root)
        output_file = File.new @output_file_path
        output_file.content = Helpers.stringify_keys(ast_root.to_h).to_yaml
        output_file.write
        ast_root
      end
    end
  end
end
