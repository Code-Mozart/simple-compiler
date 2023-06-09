require 'thor'

module Simplec
  class CLI < Thor
    default_command :compile

    desc 'compile FILE_PATH', 'Compiles the simplec source file'
    option :target,
           type: :string,
           enum: ['tokens', 'ast', 'vmcode', 'c'],
           default: 'vmcode',
           desc: 'The target representation to compile to'
    option :output_tokens, type: :boolean, default: false, desc: 'Output the tokens'
    option :output_ast, type: :boolean, default: false, desc: 'Output the tokens'
    option :output_directory, type: :string, default: nil, desc: 'The directory to output the generated files to'
    option :output_name, type: :string, default: nil, desc: 'The filename to output the generated files to'

    def compile(file_arg)
      validate_options_for_compile

      if file_arg.nil? || file_arg.empty?
        say 'Please provide a file to compile', :red
      else
        src_file = Simplec::FileHandler.find_file file_arg
        output_dir = options[:output_directory] and
          Simplec::FileHandler.find_directory(options[:output_directory])

        say "Compiling file #{src_file} to #{options[:target]}", :blue
        say "Source code:", :blue
        say src_file.content

        Simplec::Compiler.new(
          file: src_file,
          target: options[:target].to_sym,
          output_tokens: options[:output_tokens],
          output_ast: options[:output_ast],
          output_directory: output_dir,
          output_name: options[:output_name]
        ).compile
      end
    end

    def self.exit_on_failure? = true

    private

    def validate_options_for_compile
      if options[:target] == 'tokens'
        if options[:output_tokens]
          puts 'Specifying --output-tokens is redundant when compilation target is \'tokens\'.'
        end
        if options[:output_ast]
          raise 'Cannot output AST when compilation target is \'tokens\'. Instead specify \'ast\' as ' \
                ' target and set the option --output-tokens.'
        end
      elsif options[:target] == 'ast' && options[:output_ast]
        puts 'Specifying --output-ast is redundant when compilation target is \'ast\'.'
      end
    end
  end
end
