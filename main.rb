require 'rubygems'
require_relative 'listings_manager'
require_relative 'display'

# list = ListingsManager.new
# list.add_listing('http://www.ebay.com/itm/20Pcs-48W-Flood-LED-Off-road-Work-Light-Lamp-12V-24V-Cars-boat-Truck-Driving-UTE-/162342343377?hash=item25cc5b92d1:g:xOkAAOSwA3dYO5sy&vxp=mtr', [600], {})
# list.run

disp = Display.new
columns = [{ width: 40, title: 'a' }, { width: 8, title: 'b' }, { width: 8, title: 'c' }]
table = Table.new(1, 5, columns, [])
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})
table.add_row({ a: 'kumpei', b: 'kumpas', c: 'kmpainisas'})

disp.attach_table(table)
disp.temp