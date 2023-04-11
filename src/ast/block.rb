# frozen_string_literal: true

module Simplec
  module AST
    class Block < Node
      attr_reader :parameters, :body
      attr_accessor :symbol_table

      def initialize(id, file, line, column, parameters = [], body = [])
        super(id, file, line, column)
        @parameters = parameters
        @body = body
        @symbol_table = nil
      end

      def to_h
        hash = super
        hash[node_type].merge!(
          parameters: @parameters.map(&:to_h),
          body: @body.map(&:to_h)
        )
        hash
      end

      def children
        @parameters + @body
      end
    end
  end
end
