# frozen_string_literal: true

module Simplec
  class Compiler
    class Solver
      def initialize; end

      def refresh_parameters; end

      def run(ast_root)
        ast_root.symbol_table.parent = external_symbols_table
        solve ast_root, ast_root.symbol_table
        ast_root
      end

      private

      def solve(node, symbol_table)
        node.children.each do |child|
          solve child, symbol_table
        end

        solve_node node, symbol_table
      end

      def solve_node(node, symbol_table)
        case node
        when AST::Call
          solve_call node, symbol_table
        else
          # do nothing
        end
      end

      def solve_call(node, symbol_table)
        symbol = symbol_table.resolve node.identifier
        node.definition ||= symbol
        return if node.definition

        raise_error_at node, :undefined_function, node.identifier
      end

      private

      def external_symbols_table
        AST::SymbolTable.new :external, nil, nil, {
          'say' => 'extern'
        }
      end

      private

      def raise_error_at(node, type, *args)
        raise CompilationError.new type, node.file, node.line, node.column, *args
      end
    end
  end
end
