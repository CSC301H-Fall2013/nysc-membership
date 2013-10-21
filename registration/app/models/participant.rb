class Participant < ActiveRecord::Base

	# Search for all participants that match in the database
	# by fname, lname, participantID, or phone.
	def self.search(search)
	  if search
	    Participant.where(['fname LIKE ? OR lname LIKE ? OR phone LIKE ? OR participantID like ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
	  else # When page is initially loaded display no member information.
	    []
	  end
	end

	# Export all members information as a csv file.
	def self.to_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |participant|
				csv << participant.attributes.values_at(*column_names)
			end
		end

	end

	# A Participant must present a doctor's note that was written before, and including today
	def dr_note_date_cannot_be_in_the_future
		if dr_note_date.present? && dr_note_date > Date.today
			errors.add(:dr_note_date, "Can't be in the future!")
		end
	end

	#validation
	validates :participantID, :uniqueness => true;
	validates :is_member, :fname, :lname, :phone, :presence => true
	validates :expirydate, :dr_note_date, :birthday, :presence => { :message => "Date must be in DD-MM-YYYY"}, allow_nil: true
	validate :dr_note_date_cannot_be_in_the_future 

	#validates participantID to be length of
	validates :participantID, length: { is: 8 }

end
