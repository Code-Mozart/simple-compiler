# frozen_string_literal: true

require 'set'

module Simplec
  module Backends
    class CCodeGenerator
      def initialize
        @emitted_tokens = []
        @static_data = []
        @includes = {}
      end

      def refresh_parameters
        @output_format = :c
        @output_file_path = "#{Simplec.root}/#{@file.filename}.#{@output_format}"
      end

      def run(ast_root)
        generate_root_tokens ast_root

        output_file = File.new @output_file_path
        output_file.content = generate_code
        output_file.write
        ast_root
      end

      private

      def generate_root_tokens(ast_root)
        comment = "implicit main function at #{cite ast_root}"
        function_signature 'main', 'int', comment do
          variable_declaration 'int', 'argc'
          @emitted_tokens << Token.new(:comma, ',')
          variable_declaration 'char**', 'argv'
        end
        block do
          ast_root.body.each do |node|
            generate_tokens node
            @emitted_tokens << Token.new(:semicolon, ';')
          end

          @emitted_tokens << Token.new(:return, 'return', "implicit exit at #{cite ast_root}")
          @emitted_tokens << Token.new(:integer, 0)
          @emitted_tokens << Token.new(:semicolon, ';')
        end
      end

      def generate_tokens(node)
        case node
        when AST::Block
          generate_block_tokens node
        when AST::Call
          generate_call_tokens node
        when AST::String
          generate_string_tokens node
        else
          raise StandardError, "Unsupported node #{node.class}"
        end
      end

      def generate_block_tokens(node)
        raise NotImplementedError
      end

      def generate_call_tokens(node)
        if node.definition == 'extern'
          resolve_external(node.identifier, node)
        else
          identifier = node.identifier
          function_call identifier, "#{cite node} # #{node.identifier}(...)" do
            node.arguments.each do |argument|
              generate_tokens argument
              @emitted_tokens << Token.new(:comma, ',') unless argument == node.arguments.last
            end
          end
        end
      end

      def generate_string_tokens(node)
        variable = StaticVariable.new('char*', "\"#{node.value}\\0\"", "#{cite node} # \"#{node.value}\"")
        @static_data << variable
        @emitted_tokens << Token.new(:static_variable, variable)
      end

      private

      def resolve_external(identifier, *args)
        case identifier
        when 'say'
          node = args.first

          add_include 'stdio.h', 'say'
          function_call 'printf', "#{cite node} # #{node.identifier}(...)" do
            @emitted_tokens << Token.new(:string, '%s\\n')
            @emitted_tokens << Token.new(:comma, ',')
            node.arguments.each do |argument|
              generate_tokens argument
              @emitted_tokens << Token.new(:comma, ',') unless argument == node.arguments.last
            end
          end
        else
          raise StandardError, "Unsupported external identifier '#{identifier}'"
        end
      end

      def add_include(name, identifier)
        (@includes[name] ||= ::Set.new) << identifier
      end

      private

      def generate_code
        code = String.new
        generate_includes code
        generate_static_data code
        generate_emitted_tokens code
        code
      end

      def generate_includes(code)
        @includes.each do |name, identifiers|
          code << "// implicit include for Simplec symbol #{identifiers.join(', ')}\n"
          code << "#include <#{name}>\n\n"
        end
      end

      def generate_static_data(code)
        @static_data.each_with_index do |variable, index|
          variable.variable_name = "#{type_to_variable_name variable.type}_#{index}"
          code << "// #{variable.comment}\n" if variable.comment
          code << "#{variable.type} #{variable.variable_name} = #{variable.value};\n\n"
        end
      end

      def generate_emitted_tokens(code)
        indentation = 0
        @emitted_tokens.each do |token|
          write code, "// #{token.comment}\n", indentation if token.comment

          case token.type
          when :type
            write code, "#{token.value} ", indentation
          when :identifier
            write code, "#{token.value}", indentation
          when :open_parenthesis
            write code, "#{token.value}", indentation
          when :close_parenthesis
            write code, "#{token.value}", indentation
          when :open_brace
            write code, "#{token.value}\n", indentation
            indentation += 1
          when :close_brace
            indentation -= 1
            write code, "#{token.value}\n", indentation
          when :comma
            write code, "#{token.value} ", indentation
          when :semicolon
            write code, "#{token.value}\n", indentation
          when :integer
            write code, "#{token.value}", indentation
          when :string
            write code, "\"#{token.value}\"", indentation
          when :static_variable
            write code, "#{token.value.variable_name}", indentation
          when :return
            write code, "#{token.value} ", indentation
          else
            raise StandardError, "Unsupported token type #{token.type}"
          end
        end
      end

      def write(code, string, indentation)
        code << '  ' * indentation if code[-1] == "\n"
        code << string
      end

      private

      Token = Struct.new(:type, :value, :comment) do
        def initialize(type, value, comment = nil)
          super(type, value, comment)
        end
      end

      StaticVariable = Struct.new(:type, :value, :comment, :variable_name) do
        def initialize(type, value, comment = nil)
          super(type, value, comment, nil)
        end
      end

      def function_signature(name, return_type, comment = nil, &_)
        @emitted_tokens << Token.new(:type, return_type, comment)
        @emitted_tokens << Token.new(:identifier, name)
        @emitted_tokens << Token.new(:open_parenthesis, '(')
        yield
        @emitted_tokens << Token.new(:close_parenthesis, ')')
      end

      def variable_declaration(type, name, comment = nil)
        @emitted_tokens << Token.new(:type, type, comment)
        @emitted_tokens << Token.new(:identifier, name)
      end

      def block(&_)
        @emitted_tokens << Token.new(:open_brace, '{')
        yield
        @emitted_tokens << Token.new(:close_brace, '}')
      end

      def function_call(identifier, comment = nil, &_)
        @emitted_tokens << Token.new(:identifier, identifier, comment)
        @emitted_tokens << Token.new(:open_parenthesis, '(')
        yield
        @emitted_tokens << Token.new(:close_parenthesis, ')')
      end

      private

      def cite(node)
        "#{node.file.path}:#{node.line}:#{node.column}"
      end

      def type_to_variable_name(type)
        case type
        when 'char*'
          'string'
        else
          type.gsub('*', '_ptr').gsub(/[^A-Za-z_]/, '')
        end
      end
    end
  end
end
