class Course < ActiveRecord::Base

	validates :courseID, length: { is: 8 }
	validates :courseID, :uniqueness => { :scope => :startDate }

	validates :courseID, :startDate, :title, :instructor, :description,	:intesity, :additional, \
	 :duration, :startTime, :endTime, :dayOfWeek, :earlybirdPrice, :memberPrice, :nonmemberPrice, \
	  :size, :presence => true

	validates :startDate, :presence => { :message => "Date must be in DD-MM-YYYY"}

	validate :startTime_endTime_conflict

	def self.search(search)
	  if search
	    Course.where(['courseID LIKE ? ', "%#{search}%"])
	  else # When page is initially loaded display no registeration information.
	    []
	  end
	end

	def startTime_endTime_conflict
		if startTime >= endTime
			self.errors.add :startTime, "Should Be Before End Time"
		end
	end

end
