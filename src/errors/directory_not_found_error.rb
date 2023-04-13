# frozen_string_literal: true

module Simplec
  class DirectoryNotFoundError < Error
    def initialize(path)
      super "Directory not found: #{path}"
    end
  end
end
