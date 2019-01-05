require "gosu"
require "csv"

module MyTyping
  DEBUG = false

  module ZOrder
    BACKGROUND, UI = *0..1
  end

  class Window < Gosu::Window
    def initialize
      super 640, 480
      self.caption = "MyTyping"
      @font = Gosu::Font.new(20)
      @score = 0
      @input_text = ""
      @current_key = nil
      @comment = nil
      @comment_time = 0
      @dic = CSV.read("EJDict/release/ejdic-hand-utf8.txt", col_sep: "\t", quote_char: "_").to_a
      @current_word = @dic.sample
    end

    def update
      if @current_word[0].downcase == @input_text
        @comment = "complete!"
      end
      if @comment
        @comment_time += 1
      end
      if @comment_time > 100
        @score += 1
        @comment = nil
        @comment_time = 0
        @current_word = @dic.sample
        @input_text = ""
      end
    end

    def draw
      @font.draw(@current_word[0], 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw(@input_text, 10, 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw(@current_word[1], 10, 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW) if @comment
      @font.draw(@comment, 10, 70, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw(@score, 10, 90, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw(@comment_time, 10, 110, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW) if DEBUG
    end

    def button_down(id)
      case id
      when Gosu::KB_ESCAPE
        close
      when Gosu::KB_BACKSPACE
        @input_text.chop!
      else
        char = Gosu.button_id_to_char(id)
        if char != @current_key
          @input_text << char
        end
        super
      end
    end
  end
end

MyTyping::Window.new.show
