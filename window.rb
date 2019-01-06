require "gosu"
require "csv"
require "./battle"

module MyTyping
  DEBUG = false

  module ZOrder
    BACKGROUND, UI = *0..1
  end

  class Window < Gosu::Window
    attr_reader :dic

    def initialize
      super 640, 480
      self.caption = "MyTyping"
      @dic = CSV.read("EJDict/release/ejdic-hand-utf8.txt", col_sep: "\t", quote_char: "_").to_a
      @battle = Battle.new(self)
    end

    def update
      @battle.update
    end

    def draw
      @battle.draw
    end

    def button_down(id)
      case id
      when Gosu::KB_ESCAPE
        close
      else
        @battle.button_down(id)
        super
      end
    end
  end
end

MyTyping::Window.new.show
