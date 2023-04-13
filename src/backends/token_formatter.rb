# frozen_string_literal: true

require 'yaml'

module Simplec
  module Backends
    class TokenFormatter
      include Simplec::Backends::FileOutput
      default_output_format :yml
      default_output_suffix 'tokens'

      def initialize
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
