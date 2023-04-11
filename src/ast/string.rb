# frozen_string_literal: true

module Simplec
  module AST
    class String < Node
      attr_reader :value

      def initialize(id, file, line, column, value)
        super(id, file, line, column)
        @value = value
      end

      def to_h
        hash = super
        hash[node_type].merge!(
          value: @value
        )
        hash
      end
    end
  end
end
