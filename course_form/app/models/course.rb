class Course < ActiveRecord::Base


	validates :courseName, :courseCode, :instructor, :description, :intensity, :additional, :duration, :earlybirdPrice, :presence => true
	validates :startDate, :endDate, :presence => { :message => "Date must be in DD-MM-YYYY"}
	validates :startTime, :endTime, :presence => { :message => "Time must be in HH:MM"}
	validates :membersPrice, :nonmembersPrice, :presence => true



end
