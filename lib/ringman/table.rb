class Table
  def initialize(position, height, columns, data)
    @position = position
    @columns = columns
    @data = []
    @height = height
    @scroll = 0
    @pad = nil
    @window = nil
    @width = @columns.inject(0) { |sum, x| sum + x[:width] } + @columns.length + 2
  end

  attr_accessor :pad, :window, :scroll
  attr_reader :data, :position, :columns, :height, :width

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

  def needs_scrollbar?
    @height < @data.length
  end
end