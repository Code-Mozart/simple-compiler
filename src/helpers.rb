# frozen_string_literal: true

module Simplec
  module Helpers
    def self.stringify_keys(arg)
      case arg
      when Hash
        arg.each_with_object({}) do |(key, value), result|
          result[key.to_s] = stringify_keys value
        end
      when Array
        arg.map { |item| stringify_keys(item) }
      else
        arg
      end
    end
  end
end
