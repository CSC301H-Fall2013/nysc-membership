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

	# auto - generate waitlist value
	def waitlist_generate(course)
		#debugger
		if course_full
			enrollment = Enrollment.where(courseID: course).maximum("waitlist_status")
			return enrollment+1
		else 
			return 0
		end
	end

	# check if a course one attempts to enrol in, is full
	# takes a course ID as input
	def course_full
		max_enrol = Course.find_by(courseID: courseID).size
		current_enrol = Enrollment.where(courseID: courseID).count
		if current_enrol < max_enrol
			return false
		else
			return true
		end

	end

	# make sure the course exists, used for validation
	def course_exists
		if not Course.exists?(courseID: courseID)
			errors.add(:courseID, "is invalid!")
		end
	end

	#Check if enrollment ID inputs are in the database
	def self.check_validation(enrollment)
	    if Participant.find_by(participantID: enrollment.participantID) 
	    	if Course.find_by(courseID: enrollment.courseID) 
	      		return true
	    	end
	    end
	end

	#Charges participant fee by their membership and date
	def self.charge_fee(enrollment)
		if_member = Participant.find_by(participantID: enrollment.participantID)
		if_course = Course.find_by(courseID: enrollment.courseID)
		earlyBirdTime = if_course.startDate.months_ago(1)
		if if_member.expirydate > Date.today
			if Date.today >= earlyBirdTime && Date.today < if_course.startDate
				return if_course.earlybirdPrice
			else
				return if_course.memberPrice
			end
		else
			return if_course.nonmemberPrice
		end
	end


	def self.get_season #should change the years later
		if Date.today.month >= 1 && Date.today.month <= 3
			return Date.parse("2013-01-01")
		end
		if Date.today.month >= 4 && Date.today.month <= 6
			return Date.parse("2013-04-01")
		end
		if Date.today.month >= 7 && Date.today.month <= 9
			return Date.parse("2013-07-01")
		else 
			return Date.parse("2013-10-01")
		end
	end


	def pay_course
		return true
	end


	# # when user clicks the "validate" button beside the courseID input field with a courseID, create the pop-up
	# # displaying if participant will be waitlisted, and how much they will need to pay, either now or later
	# def self.gen_popup_validate(courseID)
	# 	full = self.course_full(course)
	# 	# find price to charge
	# 	if not full:
	# 		# stuff
	# 	else:
	# 		# full
	# 	end
	# end

	#Validation

	#Primary key of courseID and participantID
	validates :participantID, :presence => true, :uniqueness => {:scope => :courseID, :message => "has been already enrolled in that course"}
	validates :courseID, :presence => true, :uniqueness => {:scope => :participantID, :message => "has that participant enrolled already"}
	
	validates :courseID, length: { is: 8 }
	validate :course_exists
	validate :course_full
	validates :participantID, :courseID, :startDate, :presence => true
	validates :startDate, :presence => { :message => "Date must be in DD-MM-YYYY"}


end
