# frozen_string_literal: true

module Simplec
  class Compiler
    def initialize(file:, target: :vmcode, **options)
      @file = file
      @target = target
      @output_tokens = options[:output_tokens]
      @output_ast = options[:output_ast]
      @output_path_base = build_output_path(file, options[:output_directory], options[:output_name])
    end

    def compile
      create_pipeline
      @pipeline.run
    end

    private

    def create_pipeline
      @pipeline = Simplec::Compiler::Pipeline.new(@file, @output_path_base)

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

    def build_output_path(file, output_directory, output_name)
      dir = output_directory || file.directory
      name = output_name || file.filename
      "#{dir}/#{name}"
    end
  end
end
