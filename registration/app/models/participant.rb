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

	#validation
	validates :participantID, :uniqueness => true;
	validates :is_member, :fname, :lname, :phone, :presence => true
	validates :expirydate, :dr_note_date, :birthday, :presence => { :message => "Date must be in DD-MM-YYYY"}, allow_nil: true

	#validates participantID to be length of
	validates :participantID, length: { is: 8 }

end
