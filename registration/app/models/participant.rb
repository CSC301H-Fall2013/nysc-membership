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
end
