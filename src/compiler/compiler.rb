# frozen_string_literal: true

module Simplec
  class Compiler
    def initialize(file)
      @file = file
    end

    def compile
      raise NotImplementedError
    end
  end
end
