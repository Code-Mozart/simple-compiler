# frozen_string_literal: true

module Simplec
  class Compiler
    Token = Struct.new(:id, :file, :line, :column, :type, :value, :source_code) do
      def initialize(id, file, line, column, type, value, source_code = value)
        super(id, file, line, column, type, value, source_code)
      end

      def to_h
        {
          id: id,
          file: file.path,
          line: line,
          column: column,
          type: type,
          value: value,
          source_code: source_code
        }
      end
    end
  end
end
