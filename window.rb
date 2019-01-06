require "gosu"
require "csv"
require "./battle"

module MyTyping
  DEBUG = false

  module ZOrder
    BACKGROUND, UI = *0..1
  end

  class Window < Gosu::Window
    def initialize
      super 640, 480
      self.caption = "MyTyping"
      @battle = Battle.new
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
