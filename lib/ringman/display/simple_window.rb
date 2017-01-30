class SimpleWindow
  def initialize(width, height, title, text)
    @text = text
    @title = title
    @height = height
    @scroll = 0
    @pad = nil
    @width = width
  end

  attr_accessor :pad, :scroll
  attr_reader :text, :height, :width

  def draw(x, y)
    @pad = Curses::Pad.new(height, width) if @pad.nil?
    @pad.setpos(x, y)
    @pad.addstr('test')

    @pad.refresh(0, 0, y, x, y + height, x + width)
  end
end