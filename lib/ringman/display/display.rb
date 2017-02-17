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

  def redraw(object)
    window = @windows.detect { |w| w[:object] == object }
    return if window.nil?

    object.draw(window[:x], window[:y])
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
      @windows[0][:object].add_row({ a: 'dra', b: 'dar', c: 'dar'})
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