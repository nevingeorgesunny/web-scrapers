require 'rubygems'
require 'write_xlsx'

# Create a new Excel workbook
workbook = WriteXLSX.new('ruby.xlsx')

# Add a worksheet
worksheet = workbook.add_worksheet


# Write a formatted and unformatted string, row and column notation.
col = row = 0

worksheet.write(row,   col, "Hi Excel!")



workbook.close
