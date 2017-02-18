class SimpleWindow
  COLOR_RED = 14

  def initialize(width, height, title, text)
    @text = text
    @title = title
    @height = height
    @scroll = 0
    @pad = nil
    @width = width
    @screen = nil

    init_color(COLOR_RED, 255, 0, 0)
    init_pair(COLOR_RED, COLOR_RED, COLOR_RED)
  end

  def register(screen)
    @screen = screen
  end

  def draw(x, y)
    @pad = Curses::Pad.new(@height, @width) if @pad.nil?

    @pad.attron(color_pair(COLOR_RED)) do
      @height.times do |line|
        @pad.setpos(line, 0)
        @pad << ' ' * @width
      end
    end

    @pad.refresh(0, 0, y, x, y + @height, x + @width)
  end
end