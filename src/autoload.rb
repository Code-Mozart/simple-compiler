# frozen_string_literal: true

module Simplec
  def self.root
    ::File.expand_path('..', __dir__)
  end

  autoload :CLI, "#{Simplec.root}/src/cli"

  autoload :File, "#{Simplec.root}/src/files/file"
  autoload :FileHandler, "#{Simplec.root}/src/files/file_handler"

  autoload :Compiler, "#{Simplec.root}/src/compiler/compiler"

  autoload :Error, "#{Simplec.root}/src/errors/error"
  autoload :FileNotFoundError, "#{Simplec.root}/src/errors/file_not_found_error"
  autoload :CompilationError, "#{Simplec.root}/src/errors/compilation_error"

  class Compiler
    autoload :Pipeline, "#{Simplec.root}/src/compiler/pipeline"
    autoload :Lexer, "#{Simplec.root}/src/compiler/lexer"
    autoload :Parser, "#{Simplec.root}/src/compiler/parser"
    autoload :Solver, "#{Simplec.root}/src/compiler/solver"
  end

  module Backends
    autoload :TokenFormatter, "#{Simplec.root}/src/backends/token_formatter"
    autoload :ASTFormatter, "#{Simplec.root}/src/backends/ast_formatter"
    autoload :VMCodeGenerator, "#{Simplec.root}/src/backends/vmcode_generator"
    autoload :CCodeGenerator, "#{Simplec.root}/src/backends/ccode_generator"
  end
end
