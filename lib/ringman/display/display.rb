require 'curses'
require_relative 'table'
include Curses

class Display
  def initialize
    init_screen
    start_color
    init_color(COLOR_BLACK, 0, 0, 0)
    fill_window(stdscr, COLOR_BLACK)
    curs_set(0)
    refresh

    @windows = []
  end

  def attach(object, x, y)
    @windows.push(x: x, y: y, object: object)
    object.register(self)
    object.draw(x, y)
  end

  def redraw
    fill_window(stdscr, COLOR_BLACK)
    refresh

    @windows.each do |win|
      win[:object].draw(win[:x], win[:y])
    end
  end

  def close(object)
    window = @windows.detect { |w| w[:object] == object }

    @windows.delete(window)

    redraw
  end

  def focus(object)
    window = @windows.detect { |w| w[:object] == object }

    @windows.delete(window)
    @windows.push(window)

    redraw
  end

  def move(object, x, y)
    window = @windows.detect { |w| w[:object] == object }

    window[:x] = x
    window[:y] = y

    redraw
  end

  def temp
    while true do
      # if getch == Curses::KEY_RESIZE
      #   # File.open('log.txt', 'a+') { |file| file.write('res'+"\n") }
      #   resizeterm(Curses.lines, Curses.cols)
      #   draw_headers(@table)
      #   draw_table(@table)
      # end
      getch
      @windows[1][:object].add_row({ a: 'dra', b: 'dar', c: 'dar'})
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
