class Parq < ActiveRecord::Base

	# Export all parq information as a csv file.
	def self.to_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |parq|
				csv << parq.attributes.values_at(*column_names)
			end
		end

	end
end
