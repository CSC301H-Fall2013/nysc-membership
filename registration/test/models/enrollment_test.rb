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
		assert Participant.find_by(participantID: registered_member.participantID).is_member, "Member is not a member"
		
		# Checking the existence of the pair (courseID,startDate) 
		expected = registered_member.startDate
		actual = Course.find_by(courseID: registered_member.courseID)
		assert_equal expected, actual.startDate, "Registering Course does not have valid startDate"

		# TODO: check doctors note, parq, not yet implemented

		assert registered_member.save, "valid registered member was not saved"
	end


	# Test the result of a valid member registering into a valid course
	def test_valid_member_registering_class
		registering_member = Enrollment.new(:participantID => participants(:two).participantID, :courseID => "yoga01", :startDate => '2013-10-18')
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"
		assert Participant.find_by(participantID: registering_member.participantID).is_member, "Member is not a member"

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
		registering_member = Enrollment.new(:participantID => "abc12345", :courseID => "yoga01")
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"
		assert !Participant.find_by(participantID: registering_member.participantID), "non existent member was found in Participant database"
	end


	# Test a member registering into an unexisting course
	def test_unexistent_course_registering_member
		registering_member = Enrollment.new(:participantID => participants(:one).participantID, :courseID => "nap101")
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
 		assert !Course.find_by(courseID: registering_member.courseID), "Non existent Course is in Courses database"
	end

	# FAILURE TEST
	# Test a member registering into a full course that is full - waitlist will be tested in other cases
	def test_valid_member_registering_full_class
		registering_member = Enrollment.new(:participantID => participants(:two).participantID, :courseID => "run123", :startDate => '2013-10-18')
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"
		assert Participant.find_by(participantID: registering_member.participantID).is_member, "Member is not a member"

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
		assert !Participant.find_by(participantID: registered_non_member.participantID).is_member, "Non Member is a member"
		
		# Checking the existence of the pair (courseID, startDate)
		actual = Course.find_by(courseID: registered_non_member.courseID)
		assert_equal registered_non_member.startDate, actual.startDate, "Registering Course does not have valid startDate"
		
		assert registered_non_member.save, "valid registered member was not saved"
	end


	# Test the result of a valid non member registering into a valid course
	def test_valid_non_member_registering_in_class
		registering_non_member = Enrollment.new(:participantID => participants(:non_member_one).participantID, :courseID => "nap123", :startDate => '18-10-2013')
		assert Participant.find_by(participantID: registering_non_member.participantID), "Non Member was not found in Participant database"
		assert Course.find_by(courseID: registering_non_member.courseID), "Course is not in Courses database"
		assert !Participant.find_by(participantID: registering_non_member.participantID).is_member, "Non Member is a member"
		
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
		registering_non_member = Enrollment.new(:participantID => "abc12345", :courseID => "yoga01")
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
		registering_non_member = Enrollment.new(:participantID => participants(:non_member_one).participantID, :courseID => "walk11", :startDate =>"2013-10-18")
		assert Participant.find_by(participantID: registering_non_member.participantID), "Non Member was not found in Participant database"
		assert Course.find_by(courseID: registering_non_member.courseID), "Course is not in Courses database"
		assert !Participant.find_by(participantID: registering_non_member.participantID).is_member, "Non Member is a member"
		
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




end
