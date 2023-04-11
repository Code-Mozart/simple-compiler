# frozen_string_literal: true

module Simplec
  module AST
    class Call < Node
      attr_reader :identifier, :arguments
      attr_accessor :definition

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
          definition: (@definition&.is_a?(Node) ? @definition.id : @definition),
          arguments: @arguments.map(&:to_h)
        )
        hash
      end

      def children
        @arguments
      end
    end
  end
end
