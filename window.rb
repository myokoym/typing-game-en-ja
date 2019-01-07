require "gosu"
require "csv"
require "./battle"
require "./deck"

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
      @deck = []
      @battle = Battle.new(self)
      @deck = Deck.new(self)
      @mode = :deck
    end

    def update
      case @mode
      when :deck
        @deck.update
      when :battle
        @battle.update
      end
    end

    def draw
      case @mode
      when :deck
        @deck.draw
      when :battle
        @battle.draw
      end
    end

    def button_down(id)
      case id
      when Gosu::KB_DELETE
        close
      else
        case @mode
        when :deck
          @deck.button_down(id)
        when :battle
          @battle.button_down(id)
        end
        super
      end
    end
  end
end

MyTyping::Window.new.show
