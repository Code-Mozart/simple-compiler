# frozen_string_literal: true

module Simplec
  class File
    attr_reader :path

    def initialize(path)
      @path = path
      @content = nil
    end

    def loaded? = !@content.nil?

    def filename
      ::File.basename @path, '.*'
    end

    def content
      @content ||= ::File.read @path
    end

    def content=(content)
      @content = content
    end

    def write
      ::File.write @path, @content
    end
  end
end
