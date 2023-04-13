# frozen_string_literal: true

module Simplec
  class Compiler
    class Parser
      def initialize
        @node_count = 0
        @symbol_tables_count = 0
      end

      def run(tokens)
        @tokens = tokens
        parse
      end

      def source_file=(file)
        @file = file
      end

      private

      def parse
        ast_root = AST::Block.new 0, @file, 1, 1
        ast_root.symbol_table = AST::SymbolTable.new @symbol_tables_count, ast_root
        @symbol_tables_count = 1
        @node_count = 1

        @cursor = 0
        while more_tokens?
          ast_root.body << parse_expression(parse_tuples: true)
        end

        ast_root
      end

      def parse_expression(parse_tuples: false)
        case current_token.type
        when :identifier
          parse_identifier
        when :string
          parse_string
        else
          raise StandardError, "Unsupported token of type '#{current_token.type}'"
        end
      end

      def parse_identifier(parse_tuples: false)
        @cursor += 1
        case current_token.type
        when :identifier
          # TODO: parse operator
          raise NotImplementedError
        when :open_parenthesis
          parse_call
        when :semicolon
          # TODO: flush the current expression if possible or raise a compiler error
          raise NotImplementedError
        when :comma
          if parse_tuples
            # TODO: handle implicit tuple notation
            raise NotImplementedError
          else
            # TODO: flush the current expression if possible or raise a compiler error
            raise NotImplementedError
          end
        else
          raise CompilationError.new :unexpected_token, @file, current_token.line, current_token.column, current_token
        end
      end

      def parse_call
        call_node = build_node AST::Call, previous_token, previous_token.value

        # consume the open parenthesis
        @cursor += 1

        # parse the arguments
        while current_token.type != :close_parenthesis
          call_node.arguments << parse_expression(parse_tuples: false)

          if current_token.type == :comma
            @cursor += 1
          elsif current_token.type != :close_parenthesis
            raise StandardError, "Unexpected token '#{current_token}', expected ',' or ')'"
          end
        end

        # consume the close parenthesis
        @cursor += 1

        call_node
      end

      def parse_string
        string_node = build_node AST::String, current_token, current_token.value
        @cursor += 1
        string_node
      end

      private

      def more_tokens?
        @cursor < @tokens.count
      end

      def current_token
        @tokens[@cursor]
      end

      def previous_token
        @cursor >= 1 ? @tokens[@cursor - 1] : nil
      end

      def build_node(klass, first_token, *args)
        node_count_before = @node_count
        begin
          node = klass.new @node_count, first_token.file, first_token.line, first_token.column, *args
          @node_count += 1
          node
        rescue
          @node_count = node_count_before
          raise
        end
      end
    end
  end
end
