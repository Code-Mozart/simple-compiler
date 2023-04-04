# frozen_string_literal: true

module Simplec
  module FileHandler

    def self.find(path)
      absoulute_path = ::File.absolute_path path
      unless ::File.exist? absoulute_path
        raise FileNotFoundError, absoulute_path
      end

      File.new absoulute_path
    end

  end
end
