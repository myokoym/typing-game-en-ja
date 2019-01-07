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
      @regexp_search = true
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
        move_dic_cursor(-1)
      when Gosu::KB_DOWN
        move_dic_cursor(1)
      when Gosu::KB_PAGE_UP
        move_dic_cursor(-20)
      when Gosu::KB_PAGE_DOWN
        move_dic_cursor(20)
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

    def move_dic_cursor(movement)
      new_dic_cursor = @dic_cursor + movement
      if new_dic_cursor < 0
        @dic_cursor = 0
      elsif @searched_dic[new_dic_cursor]
        @dic_cursor = new_dic_cursor
      end
    end

    def search
      if @regexp_search
        search_text = @input_text
      else
        search_text = Regexp.escape(@input_text)
      end
      begin
        @searched_dic = @window.dic.select {|word| /#{search_text}/i =~ word[0] }
      rescue ArgumentError
        @searched_dic = []
      end
    end
  end
end
