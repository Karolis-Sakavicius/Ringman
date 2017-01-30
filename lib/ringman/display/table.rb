class Table
  HEADER_COLOR = 10
  SCROLLBAR_COLOR = 11
  THUMB_COLOR = 12
  COLOR_GREY = 13

  def initialize(position, height, columns, data)
    @position = position
    @columns = columns
    @data = []
    @height = height
    @scroll = 0
    @pad = nil
    @window = nil
    @width = @columns.inject(0) { |sum, x| sum + x[:width] } + @columns.length + 2

    initialize_colors
  end

  attr_accessor :pad, :window, :scroll
  attr_reader :data, :columns, :height, :width

  def add_row(row)
    @data.push(row)
  end

  def delete_row(row)
    deleted_row = @data.find { |r| r.merge(row) == r }
    return if deleted_row.nil?

    @data.delete(deleted_row)
  end

  def update_row(id, data)
    @data[id].merge!(data)
  end


  def draw(x, y)
    pad_height = @data.empty? ? 1 : @data.length
    @pad = Curses::Pad.new(pad_height, @width) if @pad.nil?
    @window = Curses::Window.new(1, @width, y, x) if @window.nil?

    draw_headers(x, y)
    draw_contents(x, y)
    draw_scrollbar(x, y)
  end

  def close
    @window.clear
    @window.refresh
    @window.close
    @window = nil

    @pad.clear
    @pad.refresh(0, 0, 0, 0, 0, 0)
    @pad.close
    @pad = nil
  end

  private def needs_scrollbar?
    @height < @data.length
  end

  private def draw_contents(x, y)
    pad_height = @data.empty? ? 1 : @data.length
    @pad.resize(pad_height, @width)

    @data.each_with_index do |row, index|
      @pad.setpos(index, 1)
      @columns.each do |col|
        @pad.addstr(trim_cell(row[col[:title].to_sym], col[:width]))
      end
    end

    @pad.refresh(@scroll, 0, y + 1, x, @height + y, @width + x)
  end

  private def draw_headers(x, y)
    @window.setpos(0, 1)
    @columns.each do |col|
      @window.attron(color_pair(HEADER_COLOR)) do
        @window.addstr(col[:title].center(col[:width]))
      end
      @window << ' '
    end

    @window.refresh
  end

  private def draw_scrollbar(x, y)
    unless needs_scrollbar?
      remove_scrollbar
      return
    end

    @height.times do |index|
      @pad.setpos(@scroll + index, @width - 1)
      if scroll_thumb.first <= index && scroll_thumb.last > index
        @pad.attron(color_pair(THUMB_COLOR)) do
          @pad.addch(' ')
        end
      else
        @pad.attron(color_pair(SCROLLBAR_COLOR)) do
          @pad.addch(' ')
        end
      end
    end

    @pad.refresh(@scroll, 0, y + 1, x, @height + y, @width + x)
  end

  private def scroll_thumb
    thumb_height = ((@height.to_f / @data.length.to_f) * @height.to_f).to_i
    thumb_height = 1 if thumb_height.zero?

    thumb_start = (@scroll.to_f / ((@data.length - @height).to_f / (@height - thumb_height).to_f)).to_i
    thumb_end = thumb_start + thumb_height

    [thumb_start, thumb_end]
  end

  private def remove_scrollbar
    if @height <= @data.length
      @data.length.times do |index|
        @pad.setpos(index, @width - 1)
        @pad.addch(' ')
      end
    end
  end

  private def trim_cell(str, width)
    return ' ' * (width + 1) if str.nil?

    if str.length > width
      str[0..(width - 4)] + '... '
    else
      str + ' ' * (width - str.length + 1)
    end
  end

  private def initialize_colors
    init_color(COLOR_BLACK, 0, 0, 0)
    init_color(COLOR_BLUE, 0, 0, 750)
    init_color(COLOR_GREY, 200, 200, 200)
    init_pair(THUMB_COLOR, COLOR_WHITE, COLOR_WHITE)
    init_pair(SCROLLBAR_COLOR, COLOR_GREY, COLOR_GREY)
    init_pair(HEADER_COLOR, COLOR_WHITE, COLOR_BLUE)
  end
end