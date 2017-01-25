require 'curses'
require_relative 'table'
include Curses

class Display
  HEADER_COLOR = 10
  SCROLLBAR_COLOR = 11
  THUMB_COLOR = 12
  COLOR_GREY = 13

  def initialize
    init_screen
    start_color
    init_color(COLOR_BLACK, 0, 0, 0)
    init_color(COLOR_BLUE, 0, 0, 750)
    init_color(COLOR_GREY, 200, 200, 200)
    init_pair(THUMB_COLOR, COLOR_WHITE, COLOR_WHITE)
    init_pair(SCROLLBAR_COLOR, COLOR_GREY, COLOR_GREY)
    init_pair(HEADER_COLOR, COLOR_WHITE, COLOR_BLUE)
    fill_window(stdscr, COLOR_BLACK)
    curs_set(0)
    refresh

    @table = nil
  end

  def attach_table(table)
    pad_height = table.data.empty? ? 1 : table.data.length
    table.pad = Curses::Pad.new(pad_height, table.width)
    table.window = Curses::Window.new(1, table.width, table.position, 0)
    @table = table

    draw_headers(table)
    draw_table(table)
  end

  def draw_table(table)
    pad_height = table.data.empty? ? 1 : table.data.length
    table.pad.resize(pad_height, table.width)

    table.data.each_with_index do |row, index|
      table.pad.setpos(index, 1)
      table.columns.each do |col|
        table.pad.addstr(trim_cell(row[col[:title].to_sym], col[:width]))
      end
    end

    draw_scrollbar(table)

    table.pad.refresh(table.scroll, 0, table.position + 1, 0, table.height + table.position, Curses.cols - 2)
  end

  def temp
    while true do
      if getch == Curses::KEY_RESIZE
        # File.open('log.txt', 'a+') { |file| file.write('res'+"\n") }
        resizeterm(Curses.lines, Curses.cols)
        draw_headers(@table)
        draw_table(@table)
      end
    end
  end

  def detach_table(table)
    table.window.clear
    table.window.refresh
    table.window.close
    table.window = nil

    table.pad.clear
    table.pad.refresh(0, 0, 0, 0, 0, 0)
    table.pad.close
    table.pad = nil
  end

  private def draw_headers(table)
    table.window.setpos(0, 1)
    table.columns.each do |col|
      table.window.attron(color_pair(HEADER_COLOR)) do
        table.window.addstr(col[:title].center(col[:width]))
      end
      table.window << ' '
    end

    table.window.refresh
  end

  private def trim_cell(str, width)
    return ' ' * (width + 1) if str.nil?

    if str.length > width
      str[0..(width - 4)] + '... '
    else
      str + ' ' * (width - str.length + 1)
    end
  end

  private def draw_scrollbar(table)
    unless table.needs_scrollbar?
      remove_scrollbar(table)
      return
    end

    scroll_x = table.columns.inject(0) { |sum, x| sum + x[:width] } + table.columns.length + 1
    iterations = table.data.length > table.height ? table.height : table.data.length

    iterations.times do |index|
      table.pad.setpos(table.scroll + index, scroll_x)
      if scroll_thumb(table).first <= index && scroll_thumb(table).last > index
        table.pad.attron(color_pair(THUMB_COLOR)) do
          table.pad.addch('S')
        end
      else
        table.pad.attron(color_pair(SCROLLBAR_COLOR)) do
          table.pad.addch(' ')
        end
      end
    end
  end

  private def scroll_thumb(table)
    thumb_height = ((table.height.to_f / table.data.length.to_f) * table.height.to_f).to_i
    thumb_height = 1 if thumb_height.zero?

    thumb_start = (table.scroll.to_f / ((table.data.length - table.height).to_f / (table.height - thumb_height).to_f)).to_i
    thumb_end = thumb_start + thumb_height

    [thumb_start, thumb_end]
  end

  private def remove_scrollbar(table)
    scroll_x = table.columns.inject(0) { |sum, x| sum + x[:width] } + table.columns.length + 1

    if table.height <= table.data.length
      table.data.length.times do |index|
        table.pad.setpos(index, scroll_x)
        table.pad.addch(' ')
      end
    end
  end

  private def fill_window(win, color)
    win.attron(color_pair(color)) do
      lines.times do |line|
        win.setpos(line, 0)
        win << ' ' * cols
      end
    end
  end
end