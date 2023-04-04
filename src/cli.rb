require 'thor'

module Simplec
  class CLI < Thor
    default_command :compile

    desc 'compile', 'Compiles the simplec source file'
    def compile(file_arg)
      if file_arg.nil? || file_arg.empty?
        puts 'Please provide a file to compile'
      else
        src_file = Simplec::FileHandler.find file_arg

        puts "Compiling file #{src_file}"
        puts "CONTENT ---\n#{src_file.read}\n---------"

        Simplec::Compiler.new(src_file).compile
      end
    end

    def self.exit_on_failure? = true
  end
end
