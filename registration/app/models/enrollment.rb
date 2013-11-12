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

	# auto- generate waitlist value
	def self.waitlist_generate(course, participant)
		return true
	end

	# check if a course one attempts to enrol in, is full
	# takes a course ID as input
	def course_full
		max_enrol = Course.find_by(courseID: courseID).size
		current_enrol = Enrollment.where(courseID: courseID).count
		if current_enrol < max_enrol
			waitlist_status = 0
			return false
		else
			self.waitlist_status = 1
		end

	end

	# make sure the course exists, used for validation
	def course_exists
		if not Course.exists?(courseID: courseID)
			errors.add(:courseID, "is invalid!")
		end
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
	validates :participantID, :uniqueness => { :scope => :courseID }
	validate :course_exists
	validate :course_full
	validates :participantID, :courseID, :startDate, :waitlist_status, :presence => true
	validates :startDate, :presence => { :message => "Date must be in DD-MM-YYYY"}


end
