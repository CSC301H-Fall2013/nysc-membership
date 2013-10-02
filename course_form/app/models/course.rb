class Course < ActiveRecord::Base


	validates :courseName, :courseCode, :instructor, :description, :intensity, :duration, :earlybirdPrice, :presence => true
	validates :startDate, :endDate, :presence => { :message => "Date must be in DD-MM-YYYY"}
	validates :startTime, :endTime, :presence => { :message => "Time must be in HH:MM"}
	validates :memberPrice, :nonmemberPrice, :presence => true
	validates :courseCode, :uniqueness => { :message => ": This course code already exists!"}

	#validates :courseName, :uniqueness => true;


end
