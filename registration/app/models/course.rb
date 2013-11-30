class Course < ActiveRecord::Base

	validates :courseID, length: { is: 8 }
	validates :courseID, :uniqueness => { :scope => :startDate }

	validates :courseID, :startDate, :title, :instructor, :description,	:intensity, :additional, \
	 :duration, :startTime, :endTime, :dayOfWeek, :earlybirdPrice, :memberPrice, :nonmemberPrice, \
	  :size, :presence => true

	validates :startDate, :presence => { :message => "Date must be in DD-MM-YYYY"}

	validate :startTime_endTime_conflict
	validates :intensity, :inclusion => { :in => 0..3, :message => "must be between 0 and 3" }

	# all prices and class sizes must be non-negative
	validates_numericality_of :earlybirdPrice, :memberPrice, :nonmemberPrice, \
	  :size, :only_integer =>true, :greater_than_or_equal_to =>0, :message => "must be non-negative"

	def self.search(search)
	  if search
	    Course.where(['courseID LIKE ? OR title LIKE ? OR startDate LIKE ? ', "%#{search}%", "%#{search}%", "%#{search}%"])    
	  else # When page is initially loaded display all courses available.
	    find(:all)
	  end
	end

	def startTime_endTime_conflict
		if startTime >= endTime
			self.errors.add :startTime, "Should Be Before End Time"
		end
	end

	def set_refunds
		courseList = Enrollment.where(:courseID => self.courseID)
		courseList.each do |p|
			if if_member(p.participantID)
				p.refund_back = self.memberPrice + p.refund_back
				p.save
				return true
			else
				p.refund_back = self.nonmemberPrice + p.refund_back
				p.save
				return true
			end
		end
		return false
	end	

	def if_member(member)
		if_member = Participant.find_by(participantID: member)
		if if_member != nil
			if if_member.expirydate > Date.today
				return true
			else
				return false
			end
		end
	end

	


end
