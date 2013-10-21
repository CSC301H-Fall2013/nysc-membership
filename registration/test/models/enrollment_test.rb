require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  
  	#Test Validation for Enrollments
	class Enrollments < ActiveRecord::Base
	  	validates :participantID, :uniqueness => { :scope => :courseID }
	  	validates_presence_of :participantID, :courseID, :startDate, :waitlist_status
	end

#-------------------- User Story 13 -----------------

	#Test the result if a registered member has the proper values
	def test_valid_member_registered_class
		registered_member = enrollments(:one)
		assert Participant.find_by(participantID: registered_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registered_member.courseID), "Course is not in Courses database"
		expected = registered_member.startDate
		actual = Course.find_by(courseID: registered_member.courseID)
		assert_equal expected, actual.startDate, "Registering Course does not have valid startDate"

		#TODO: check doctors note, parq, not yet implemented

		assert registered_member.save, "valid registered member was not saved"
	end


	#Test the result of a valid member registering into a valid course
	def test_valid_member_registering_class
		registering_member = Enrollment.new(:participantID => participants(:one).participantID, :courseID => "yoga01")
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"

		#TODO: check doctors note, parq, not yet implemented
		
		#checking if class is full or not
		current_enrollment = Enrollments.where(courseID: registering_member.courseID).count
		actual = Course.find_by(courseID: registering_member.courseID)
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full"

		registering_member.startDate = actual.startDate
		registering_member.waitlist_status = 0

		assert registering_member.save, "registering a new valid member was not saved"
	end


	#Test an unexistent member registering into a course, need only to check if member was in, otherwise useless cases after
	def test_unexistent_member_registering
		registering_member = Enrollment.new(:participantID => "abc12345", :courseID => "yoga01")
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"
		assert !Participant.find_by(participantID: registering_member.participantID), "non existent member was found in Participant database"
	end


	#Test a member registering into an unexisting course
	def test_unexistent_course_registering
		registering_member = Enrollment.new(:participantID => participants(:one).participantID, :courseID => "nap101")
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
 		assert !Course.find_by(courseID: registering_member.courseID), "Non existent Course is in Courses database"
	end


	#Test a member registering into a full course that is full - waitlist will be tested in other cases
	#We are just invoking for the member not to get into the course
	def test_valid_member_registering_full_class
		registering_member = Enrollment.new(:participantID => participants(:one).participantID, :courseID => "run123")
		assert Participant.find_by(participantID: registering_member.participantID), "Member was not found in Participant database"
		assert Course.find_by(courseID: registering_member.courseID), "Course is not in Courses database"

		#TODO: check doctors note, parq, not yet implemented
		
		#checking if class is full or not
		current_enrollment = Enrollments.where(courseID: registering_member.courseID).count
		actual = Course.find_by(courseID: registering_member.courseID)
		assert_operator current_enrollment, :<, actual.size, "The size of the course is full"

		registering_member.startDate = actual.startDate
		registering_member.waitlist_status = 1

		assert registering_member.save, "registering a new valid member was not saved"
	end


end
