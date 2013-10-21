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

	# Updates a participant's expiry date by one year
	def self.renew(participant)
		if (participant.expirydate < Date.today) #membership has expired, membership should be renewed from today's date
			participant.expirydate = Date.today + 1.year
		else # membership has not yet expired - membership should be renewed from the expiry date
			participant.expirydate = participant.expirydate + 1.year
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

	#validation
	validates :participantID, :uniqueness => true;
	validates :is_member, :fname, :lname, :phone, :presence => true
	validates :expirydate, :dr_note_date, :birthday, :presence => { :message => "Date must be in DD-MM-YYYY"}, allow_nil: true

	#validates participantID to be length of
	validates :participantID, length: { is: 8 }

end
