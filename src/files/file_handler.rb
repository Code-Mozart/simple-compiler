# frozen_string_literal: true

module Simplec
  module FileHandler

    def self.find_file(path)
      absolute_path = ::File.absolute_path path
      unless ::File.exist? absolute_path
        raise FileNotFoundError, absolute_path
      end

      File.new absolute_path
    end

    def self.find_directory(path)
      absolute_path = ::File.absolute_path path
      unless ::File.directory? absolute_path
        raise DirectoryNotFoundError, absolute_path
      end

      absolute_path
    end

  end
end
