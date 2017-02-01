require 'csv'

CSV.open("output.csv", "a") do |csv|
	csv << ["artone", "left_2"]

end
