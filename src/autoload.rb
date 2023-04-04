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
end
