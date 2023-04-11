# frozen_string_literal: true

module Simplec
  module AST
    Node = Struct.new(:id, :file, :line, :column) do
      def to_h
        {
          node_type => {
            id: id,
            file: file.path,
            line: line,
            column: column
          }
        }
      end

      def node_type
        self.class.name.split('::').last.downcase.gsub /( )/, '_'
      end
    end
  end
end
