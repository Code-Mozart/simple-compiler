# frozen_string_literal: true

module Simplec
  class Compiler
    class Lexer
      def initialize
        @tokens = []
      end

      def refresh_parameters; end

      def run(source_code)
        @source_code = source_code
        tokenize
      end

      private

      def tokenize
        @line = 1
        @column = 1
        @cursor = 0

        until @cursor < @source_code.length
          case current_char
          when /\s/
            handle_whitespace
            next
          when /[a-zA-Z_<>:+\-\/*\\^~|$&%§#'=?!]/
            handle_identifier
          when /[0-9]/
            handle_number
          when '"'
            handle_string
          when /[(){}\[\].,;]/
            handle_punctuation
            next
          else
            raise CompilationError.new :unknown_character, @file, @line, @column, current_char
          end

          # identifier-, number- and string-handlers must have encountered a terminating character so we
          # need to go back one character and let the next iteration handle it. This is sometimes skipped with
          # the next keyword.
          @cursor -= 1
          @column -= 1

          # check for line comments
          if char == '/' && source_code[i + 1] == '/'
            comment = ''
            column += 2
            while source_code[column] != "

            "
              comment += source_code[column]
              column += 1
            end
            column += 1
            @tokens << Token.new(:line_comment, @file, line, column, :line_comment, comment)
            next
          end

          # check for block comments
          if char == '/' && source_code[i + 1] == '{'
            comment = ''
          end
        end
      end

      def handle_whitespace
        if current_char == "\n"
          @line += 1
          @column = 1
        else
          @column += 1
        end
      end

      def handle_identifier
        identifier = @char
        @column += 1
        @cursor += 1
        while @source_code[@cursor] =~ /[a-zA-Z0-9_<>:+\-\/*\\^~|$&%§#'=?!]/
          if previous_char_was? '/'
            if current_char == '/'
              @cursor += 1
              @column += 1
              handle_line_comment
              return
            elsif current_char == '{'
              @cursor += 1
              @column += 1
              handle_block_comment
              return
            end
          end

          identifier += current_char
          @column += 1
          @cursor += 1
        end

        # TODO: handle keywords

        add_token :identifier, identifier
      end

      def handle_number
        if previous_char_was? '.'
          raise CompilationError.new(:number_starting_with_period, @file, @line, @column)
        end

        has_period = false
        number_string = @char
        @column += 1
        @cursor += 1

        while @source_code[@cursor] =~ /[0-9_]/ or (!has_period and @source_code[@cursor] == '.')
          if chars_next_to_another?('_', '.') or chars_next_to_another?('.', '_')
            raise CompilationError.new(:underscore_in_number_around_period, @file, @line, @column)
          end

          number_string += @source_code[@cursor]
          @column += 1
          @cursor += 1
        end

        number = number_string.gsub('_', '')

        if has_period
          add_token :float, number.to_f, number_string
        else
          add_token :integer, number.to_i, number_string
        end
      end

      def handle_string
        string = @cursor
        @column += 1
        @cursor += 1

        until eof? do
          string += current_char
          @column += 1
          @cursor += 1

          # TODO: handle escape sequences

          break if current_char == '"' and !previous_char_was? '\\'
        end

        add_token :string, string[1...-1], string
      end

      def handle_punctuation
        case current_char
        when '('
          add_token :open_parenthesis, current_char
        when ')'
          add_token :close_parenthesis, current_char
        when '{'
          add_token :open_brace, current_char
        when '}'
          add_token :close_brace, current_char
        when '['
          add_token :open_bracket, current_char
        when ']'
          add_token :close_bracket, current_char
        when '.'
          add_token :period, current_char
        when ','
          add_token :comma, current_char
        when ';'
          add_token :semicolon, current_char
        else
          raise CompilationError.new(:unknown_punctuation, @file, @line, @column, current_char)
        end
      end

      def handle_line_comment
        comment = ''
        until current_char == "\n"
          comment += current_char
          @column += 1
          @cursor += 1
        end
        @column += 1
        @cursor += 1
        @line += 1

        add_token :line_comment, comment, "//#{comment}"
      end

      def handle_block_comment
        comment = ''
        until chars_next_to_another? '}', '/'
          comment += current_char
          @column += 1
          @cursor += 1

          if current_char == "\n"
            @line += 1
            @column = 1
          end
        end
        @column += 2
        @cursor += 2

        add_token :block_comment, comment, "/{#{comment}}/"
      end

      def eof?
        @cursor >= @source_code.length
      end

      def current_char
        @char = @source_code[@cursor]
      end

      def previous_char_was?(char)
        @cursor >= 1 and @source_code[@cursor - 1] == char
      end

      def chars_next_to_another?(previous, current)
        previous_char_was?(previous) and current_char == current
      end

      def add_token(type, value, source_code = value)
        @tokens << Token.new(@tokens.length, @file, @line, @column, type, value, source_code)
      end
    end
  end
end
