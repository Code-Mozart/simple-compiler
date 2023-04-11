# frozen_string_literal: true

module Simplec
  class Compiler
    def initialize(file:, target: :vmcode, **options)
      @file = file
      @target = target
      @output_tokens = options[:output_tokens]
      @output_ast = options[:output_ast]
    end

    def compile
      create_pipeline
      @pipeline.run
    end

    private

    def create_pipeline
      @pipeline = Simplec::Compiler::Pipeline.new(@file)

      @pipeline << Simplec::Compiler::Lexer.new
      if @target == :tokens or @output_tokens
        @pipeline << Simplec::Backends::TokenFormatter.new
        return if @target == :tokens
      end

      @pipeline << Simplec::Compiler::Parser.new
      @pipeline << Simplec::Compiler::Solver.new
      if @target == :ast or @output_ast
        @pipeline << Simplec::Backends::ASTFormatter.new
        return if @target == :ast
      end

      case @target
      when :vmcode
        @pipeline << Simplec::Backends::VMCodeGenerator.new
      when :c
        @pipeline << Simplec::Backends::CCodeGenerator.new
      end
    end
  end
end
