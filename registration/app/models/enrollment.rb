class Enrollment < ActiveRecord::Base


	# Search for all participants that match in the database
	# by participantID, courseID, or startDate
	def self.search(search)
	  if search
	    Enrollment.where(['participantID LIKE ? OR courseID LIKE ? OR startDate LIKE ? ', "%#{search}%", "%#{search}%", "%#{search}%"])
	  else # When page is initially loaded display no registeration information.
	    []
	  end
	end

	def self.waitlist_generate(course, participant)
		return true
	end

	#Validation
	validates :participantID, :uniqueness => { :scope => :courseID }

	validates :participantID, :courseID, :startDate, :waitlist_status, :waitlist_price, :presence => true
	validates :startDate, :presence => { :message => "Date must be in DD-MM-YYYY"}


end
