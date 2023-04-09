# frozen_string_literal: true

module Simplec
  class Compiler
    Token = Struct.new(:id, :file, :line, :column, :type, :value, :source_code) do
      def initialize(id, file, line, column, type, value, source_code = value)
        super(id, file, line, column, type, value, source_code)
      end
    end
  end
end
