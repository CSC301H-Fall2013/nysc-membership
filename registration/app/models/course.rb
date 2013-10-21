class Course < ActiveRecord::Base

	validates :courseID, length: { is: 8 }
	validates :courseID, :uniqueness => { :scope => :startDate }

	validates :courseID, :startDate, :title, :instructor, :description,	:intesity, :additional, :duration, :startTime, :endTime, :dayOfWeek, :earlybirdPrice, :memberPrice, :nonmemberPrice, :size, :presence => true

end
