# frozen_string_literal: true

module Simplec
  module AST
    class Block < Node
      attr_reader :parameters, :body

      def initialize(id, file, line, column, parameters = [], body = [])
        super(id, file, line, column)
        @parameters = parameters
        @body = body
      end

      def to_h
        hash = super
        hash[node_type].merge!(
          parameters: @parameters.map(&:to_h),
          body: @body.map(&:to_h)
        )
        hash
      end
    end
  end
end
