# frozen_string_literal: true

module Simplec
  class FileNotFoundError < Error
    def initialize(path)
      super "File not found: #{path}"
    end
  end
end
