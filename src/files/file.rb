# frozen_string_literal: true

module Simplec
  class File
    attr_reader :path

    def initialize(path)
      @path = path
      @content = nil
    end

    def loaded? = !@content.nil?

    def content
      @content ||= File.read @path
    end
  end
end
