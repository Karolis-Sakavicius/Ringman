require 'rubygems'
require_relative 'ringman/listings_manager'
require_relative 'ringman/display/display'
require_relative 'ringman/display/simple_window'

disp = Display.new
columns = [{ width: 40, title: 'a' }, { width: 8, title: 'b' }, { width: 8, title: 'c' }]
table = Table.new(1, 5, columns, [])
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})

disp.attach(table, 3, 3)

table.add_row({ a: 'naujas', b: 'redraw', c: 'kmpainisas'})
disp.temp