class MemberEnrollment < ActiveRecord::Base
	attr_writer :current_step

	# Validation
	validate :valid_participant, :valid_course, :if => lambda { |o| o.current_step == "init_mem" }
	validates :participantID, :presence => true, :uniqueness => {:scope => 
		:courseID, :message => "has been already enrolled in that course"}, :if => lambda { |o| o.current_step == "init_mem" }

	#----------------------------------------------#
	# for multi-step enrollment form
	# adapted from http://railscasts.com/episodes/217-multistep-forms
	def current_step
	  @current_step || steps.first
	end

	def steps
	  %w[init_mem parq_mem pay_mem]
	end

	def next_step
	  self.current_step = steps[steps.index(current_step) + 1]
	end

	def previous_step
	  self.current_step = steps[steps.index(current_step) - 1]
	end

	def first_step?
	  current_step == steps.first
	end

	def last_step?
	  current_step == steps.last
	end

	def all_valid?
	  steps.all? do |step|
	    self.current_step = step
	    valid?
	  end
	end

	#--------------------------------------------------#

	# check if fitness is between 1-3
	def check_fitness
		course = Course.find_by(courseID: courseID)
		return course.intensity > 0
	end

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
	def waitlist_generate
		if course_full
			if Course.find_by(courseID: courseID).size > 0
				enrollment = Enrollment.where(courseID: courseID).maximum("waitlist_status")
				return enrollment + 1
			else
				return 1
			end
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

	#Check if enrollment ID inputs are in the database
	def valid_participant
	    if not Participant.find_by(participantID: participantID)
	    	errors.add(:participantID, 'is not valid. Please enter a valid ID (8 characters)')
	    end
	end

	# Check if course ID input is in db
	def valid_course
		if not Course.find_by(courseID: courseID)
			errors.add(:courseID, 'is not valid. Please enter a valid ID (8 characters)')
		end
	end

	# Charges participant fee by their membership and date
	def charge_fee
		if_member = Participant.find_by(participantID: participantID)
		if_course = Course.find_by(courseID: courseID)
		
		if if_course != nil && if_member != nil
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
	end

	def get_start_date
		return Course.find_by(courseID: courseID).startDate
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

end
