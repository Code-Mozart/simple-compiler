# frozen_string_literal: true

module Simplec
  module AST
    class Call < Node
      attr_reader :identifier, :definition, :arguments

      def initialize(id, file, line, column, identifier, definition = nil, arguments = [])
        super(id, file, line, column)
        @identifier = identifier
        @definition = definition
        @arguments = arguments
      end

      def to_h
        hash = super
        hash[node_type].merge!(
          identifier: @identifier,
          definition: @definition,
          arguments: @arguments.map(&:to_h)
        )
        hash
      end
    end
  end
end
