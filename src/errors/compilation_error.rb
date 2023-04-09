# frozen_string_literal: true

module Simplec
  class CompilationError < Error
    attr_reader :type, :file, :line, :column, :args

    def initialize(type, file, line, column, *args)
      @type = type
      @file = file
      @line = line
      @column = column
      @args = args

      super "Compilation error of type #{type} at #{file}:#{line}:#{column} with args #{args}"
    end
  end
end
