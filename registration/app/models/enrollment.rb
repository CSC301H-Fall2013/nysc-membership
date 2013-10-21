class Enrollment < ActiveRecord::Base

	validates :participantID, :uniqueness => { :scope => :courseID }

	validates :participantID, :courseID, :startDate, :waitlist_status, :presence => true
	validates :startDate, :presence => { :message => "Date must be in DD-MM-YYYY"}


end
