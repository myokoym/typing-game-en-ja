module MyTyping
  class Deck
    DECK, DICTIONARY = *0..1

    def initialize(window)
      @window = window
      @font = Gosu::Font.new(20)
      @current_cursor = DECK
      @deck_cursor = 0
      @dic_cursor = 0
      @no_searched_dic_cursor = 0
      @input_text = ""
      @searched_dic = @window.dic
    end

    def update
    end

    def draw
      @font.draw("search: ", 10, 5, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw(@input_text, 80, 5, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @dic_cursor.upto(@dic_cursor + 20).each_with_index do |i, index|
        next unless @searched_dic[i]
        @font.draw("#{@searched_dic[i][0]} ... #{@searched_dic[i][1]}",
                   10, 40 + index * 20,
                   ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      end
    end

    def button_down(id)
      case id
      when Gosu::KB_ESCAPE
        close
      when Gosu::KB_BACKSPACE
        save_cursor
        @input_text.chop!
        search
      when Gosu::KB_UP
        @dic_cursor -= 1
        @dic_cursor = 0 if @dic_cursor < 0
      when Gosu::KB_DOWN
        @dic_cursor += 1
      else
        char = Gosu.button_id_to_char(id)
        if char != @current_key
          save_cursor
          @input_text << char
          search
        end
      end
    end

    private
    def save_cursor
      if @input_text.empty?
        @no_searched_dic_cursor = @dic_cursor
      end
    end

    def load_or_rest_cursor
      if @input_text.empty?
        @dic_cursor = @no_searched_dic_cursor
      else
        @dic_cursor = 0
      end
    end

    def search
      @searched_dic = @window.dic.select {|word| /#{Regexp.escape(@input_text)}/i =~ word[0] }
      load_or_rest_cursor
    end
  end
end
