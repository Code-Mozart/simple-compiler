# frozen_string_literal: true

module Simplec
  module AST
    SymbolTable = Struct.new(:id, :node, :parent, :symbols) do
      def initialize(id, node, parent = nil, symbols = {})
        super id, node, parent, symbols
      end

      def resolve(identifier)
        symbols[identifier] || parent&.resolve(identifier)
      end
    end
  end
end
