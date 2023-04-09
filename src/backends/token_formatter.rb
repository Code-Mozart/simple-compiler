# frozen_string_literal: true

require 'yaml'

module Simplec
  module Backends
    class TokenFormatter
      def initialize
      end

      def refresh_parameters
        @output_format = :yml
        @output_file_path = "#{Simplec.root}/#{@file.filename}.tokens.#{@output_format}"
      end

      def run(tokens)
        output_file = File.new @output_file_path
        output_file.content = tokens.to_yaml
        output_file.write
      end
    end
  end
end
