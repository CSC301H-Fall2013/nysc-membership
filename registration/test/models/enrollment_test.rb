require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  
  	#Test Validation for Enrollments
	class Enrollments < ActiveRecord::Base
	  	validates :participantID, :uniqueness => { :scope => :courseID }
	  	validates_presence_of :participantID, :courseID, :startDate, :waitlist_status
	end

#-------------------- Summary for User Stories 13 & 15 -----------------
# When Reisgering either a member or non member into the Enrollment database, we would first check the following
# 	If (non) member is in registered in the Participant database
# 	If the course that is being requested to register is in the Courses database
# 	If the course is valid for the startDate they are requesting for
# 	If the course is not a full capaicity, if so, waistlist number will be invoked to 1

#-------------------- User Story 13 -----------------

	# Test the result if a registered member has the proper values
	def test_valid_member_registered_class
		registered_member = enrollments(:one)
		assert Participant.find_by(participantID: registered_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registered_member.courseID), "Course is not in Courses database"
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		member = Participant.find_by(participantID: registered_member.participantID)
		assert_operator Date.today, :<=, member.expirydate, "Member is not a member"
		assert_not_nil member.expirydate, "Member is not a member"

		
		# Checking the existence of the pair (courseID,startDate) 
		expected = registered_member.startDate
		actual = Course.find_by(courseID: registered_member.courseID)
		assert_equal expected, actual.startDate, "Registering Course does not have valid startDate"

		# TODO: check doctors note, parq, not yet implemented

		assert registered_member.save, "valid registered member was not saved"
	end

		# Test the result of a valid member registering into a valid course
	def test_valid_member_registering_class
		registering_member = Enrollment.new(:participantID => participants(:two).participantID, :courseID => "yoga0123", :startDate => '2013-10-18')
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		member = Participant.find_by(participantID: registering_member.participantID)
		assert_operator Date.today, :<=, member.expirydate, "Member is not a member"
		assert_not_nil member.expirydate, "Member is not a member"

		# Checking the existence of the pair (courseID,startDate) 
		actual = Course.find_by(courseID: registering_member.courseID)
		assert_equal registering_member.startDate, actual.startDate, "Registering Course does not have valid startDate"

		# TODO: check doctors note, parq, not yet implemented
		
		# Checking the capacity of the course
		current_enrollment = Enrollments.where(courseID: registering_member.courseID).count
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full"

		# Adding proper values before saving
		registering_member.startDate = actual.startDate
		registering_member.waitlist_status = 0

		assert registering_member.save, "registering a new valid member was not saved"
	end

	# Test an unexistent member registering into a course, need only to check if member was in, otherwise useless cases after
	def test_unexistent_member_registering
		registering_member = Enrollment.new(:participantID => "abc12345", :courseID => "yoga0123")
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"
		assert !Participant.find_by(participantID: registering_member.participantID), "non existent member was found in Participant database"
	end

	# Test a member registering into an unexisting course
	def test_unexistent_course_registering_member
		registering_member = Enrollment.new(:participantID => participants(:one).participantID, :courseID => "nap09877")
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
 		assert !Course.find_by(courseID: registering_member.courseID), "Non existent Course is in Courses database"
	end

	# FAILURE TEST
	# Test a member registering into a full course that is full - waitlist will be tested in other cases
	def test_valid_member_registering_full_class
		registering_member = Enrollment.new(:participantID => participants(:two).participantID, :courseID => "run12345", :startDate => '2013-10-18')
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		member = Participant.find_by(participantID: registering_member.participantID)
		assert_operator Date.today, :<=, member.expirydate, "Member is not a member"
		assert_not_nil member.expirydate, "Member is not a member"


		# Checking the existence of the pair (courseID,startDate) 
		actual = Course.find_by(courseID: registering_member.courseID)
		assert_equal registering_member.startDate, actual.startDate, "Registering Course does not have valid startDate"

		#TODO: check doctors note, parq, not yet implemented
		
		#Checking the capacity of the course
		current_enrollment = Enrollments.where(courseID: registering_member.courseID).count
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full"

		# Adding proper values before saving
		registering_member.startDate = actual.startDate
		registering_member.waitlist_status = 1

		assert registering_member.save, "registering a new valid member was not saved"
	end

#-------------------- User Story 15 -----------------

	# Test the result if a registered non member has the proper values
	def test_valid_non_member_registered_class
		registered_non_member = enrollments(:non_member_one)
		assert Participant.find_by(participantID: registered_non_member.participantID), "Non Member was not found in Participant database"
		assert Course.find_by(courseID: registered_non_member.courseID), "Course is not in Courses database"
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		member = Participant.find_by(participantID: registered_non_member.participantID)
		assert_nil member.expirydate, "Non Member is a member"

		# Checking the existence of the pair (courseID, startDate)
		actual = Course.find_by(courseID: registered_non_member.courseID)
		assert_equal registered_non_member.startDate, actual.startDate, "Registering Course does not have valid startDate"
		
		assert registered_non_member.save, "valid registered member was not saved"
	end

	# Test the result of a valid non member registering into a valid course
	def test_valid_non_member_registering_in_class
		registering_non_member = Enrollment.new(:participantID => participants(:non_member_one).participantID, :courseID => "nap12345", :startDate => '18-10-2013')
		assert Participant.find_by(participantID: registering_non_member.participantID), "Non Member was not found in Participant database"
		assert Course.find_by(courseID: registering_non_member.courseID), "Course is not in Courses database"
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		member = Participant.find_by(participantID: registering_non_member.participantID)
		assert_nil member.expirydate, "Non Member is a member"

		# Checking the existence of the pair (courseID,startDate) 
		expected = registering_non_member.startDate
		actual = Course.find_by(courseID: registering_non_member.courseID)
		assert_equal expected, actual.startDate, "Registering Course does not have valid startDate"

		# Checking the capacity of the course
		current_enrollment = Enrollments.where(courseID: registering_non_member.courseID).count
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full"

		# Adding proper values before saving
		registering_non_member.waitlist_status = 0

		assert registering_non_member.save, "registering a new valid non member was not saved"
	end


	# Test an unexistent non member registering into a course, need only to check if member was in, otherwise useless cases after
	def test_unexistent_non_member_registering
		registering_non_member = Enrollment.new(:participantID => "abc12345", :courseID => "yoga0123")
		assert Course.find_by(courseID: registering_non_member.courseID), "Course is not in Courses database"
		assert !Participant.find_by(participantID: registering_non_member.participantID), "non existent non member was found in Participant database"
	end


	# Test a non member registering into an unexisting course
	def test_unexistent_course_registering_non_member
		registering_non_member = Enrollment.new(:participantID => participants(:non_member_one).participantID, :courseID => "nap101")
		assert Participant.find_by(participantID: registering_non_member.participantID), "Non Member was not found in Participant database"
 		assert !Course.find_by(courseID: registering_non_member.courseID), "Non existent Course is in Courses database"
	end

	# FAILURE TEST 
	# Test a non member registering into a full course that is full - waitlist will be tested in other cases
	def test_valid_non_member_registering_full_class
		registering_non_member = Enrollment.new(:participantID => participants(:non_member_one).participantID, :courseID => "walk1122", :startDate =>"2013-10-18")
		assert Participant.find_by(participantID: registering_non_member.participantID), "Non Member was not found in Participant database"
		assert Course.find_by(courseID: registering_non_member.courseID), "Course is not in Courses database"
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		member = Participant.find_by(participantID: registering_non_member.participantID)
		assert_nil member.expirydate, "Non Member is a member"

		# Checking the existence of the pair (courseID,startDate) 
		actual = Course.find_by(courseID: registering_non_member.courseID)
		assert_equal registering_non_member.startDate, actual.startDate, "Registering Course does not have valid startDate"


		# Checking the capacity of the course
		current_enrollment = Enrollments.where(courseID: registering_non_member.courseID).count
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full"

		# Adding proper values before saving
		registering_non_member.startDate = actual.startDate
		registering_non_member.waitlist_status = 1

		assert registering_non_member.save, "registering a new valid member was not saved"
	end


#-------------------- User Story 14 -----------------

	# Test expectated waitlist non member's waitlist_status
	def test_waistlisted_nonmember
		non_member = enrollments(:non_member_two)
		expected = 1
		assert_equal expected, non_member.waitlist_status, "Supposedly waitlisted non member is not waitlisted"
	end

	# Test expectated waitlist member's waitlist_status
	def test_waitlisted_member
		member = enrollments(:three)
		expected = 1
		assert_equal expected, member.waitlist_status, "Supposedly waitlisted member is not waitlisted"
	end

	# Test adding a member to be waitlisted
	def test_adding_to_waitlist_member
		member = Enrollments.new(:participantID => participants(:six).participantID,:courseID => "run12345", :startDate => '2013-10-18' )
	
		#Checking the capacity of the course
		actual = Course.find_by(courseID: member.courseID)
		current_enrollment = Enrollments.where(courseID: member.courseID).count
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full, should fail since we are going to be waitlisting"

		# Adding proper values before saving
		member.startDate = actual.startDate
		member.waitlist_status = 1

		assert member.save, "registering a new valid member was not saved"

		waitlisted_member = Enrollments.find_by(participantID: member.participantID)
		expected = 1
		assert expected, waitlisted_member.waitlist_status, "Saved member's waitlist_status is false"
	end

	# Test adding a non member to be waitlisted
	def test_adding_to_waitlist_non_member
		non_member = Enrollments.new(:participantID => participants(:non_member_one).participantID,:courseID => "run12345", :startDate => '2013-10-18' )
	
		#Checking the capacity of the course
		actual = Course.find_by(courseID: non_member.courseID)
		current_enrollment = Enrollments.where(courseID: non_member.courseID).count
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full, should fail since we are going to be waitlisting"

		# Adding proper values before saving
		non_member.startDate = actual.startDate
		non_member.waitlist_status = 1

		assert non_member.save, "registering a new valid non_member was not saved"

		waitlisted_member = Enrollments.find_by(participantID: non_member.participantID)
		expected = 1
		assert expected, waitlisted_member.waitlist_status, "Saved non_member's waitlist_status is false"
	end



#-------------------- User Story 16 -----------------

	# Test for member to register during early bird session
	def test_member_registering_early_bird
		member = Enrollments.new(:participantID => participants(:six).participantID,:courseID => "run12345", :startDate => '2013-10-18' )
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		assert_operator Date.today, :<=, participants(:six).expirydate, "Member is not a member"
		assert_not_nil participants(:six).expirydate, "Member is not a member"

		early_bird_last_date = '2013-11-01'

		#Date.today since creating the enrollment will of today
		assert_operator Date.today, :<, Date.parse(early_bird_last_date), "Member registered too late for early bird"
	end

	# Test non member registering for early bird, not allow
	def test_non_member_registering_early_bird
		non_member = Enrollments.new(:participantID => participants(:non_member_one).participantID,:courseID => "run12345", :startDate => '2013-10-18' )
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		assert_nil participants(:non_member_one).expirydate, "Member is not a member"

		early_bird_last_date = '2013-11-01'

		#Date.today since creating the enrollment will of today
		assert_operator Date.today, :<, Date.parse(early_bird_last_date), "Member registered too late for early bird"
	end

	# FAILURE TEST
	# Test for registering for early bird after date has past
	def test_member_register_after_early_bird
		member = Enrollments.new(:participantID => participants(:six).participantID,:courseID => "run12345", :startDate => '2013-10-18' )
		
		# Checking if the member exists by the expiry date to be greater than tomorrow's date, but if nil or expired date, then participant is not a member
		assert_operator Date.today, :<=, participants(:six).expirydate, "Member is not a member"
		assert_not_nil participants(:six).expirydate, "Member is not a member"

		early_bird_last_date = '2013-09-01'

		#Date.today since creating the enrollment will of today
		assert_operator Date.today, :<, Date.parse(early_bird_last_date), "Member registered too late for early bird"
	end



end