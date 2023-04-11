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
        output_file.content = Helpers.stringify_keys(tokens.map(&:to_h)).to_yaml
        output_file.write
        tokens
      end
    end
  end
end
