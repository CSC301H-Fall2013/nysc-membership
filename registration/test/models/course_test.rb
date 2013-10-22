require 'test_helper'

class CourseTest < ActiveSupport::TestCase

	class Course < ActiveRecord::Base
	  	validates_uniqueness_of :courseID
	  	validates_presence_of :courseID, :instructor, :description, :startDate, :startTime, :endTime, :duration, :earlybirdPrice, :memberPrice, :nonmemberPrice
	end


	# Test case for unvalid cases
	def test_course_should_not_save
		course = Course.new
		assert !course.save, "Saved the course without required inputs"
	end

	# Test case for valid saves
	def test_create_save
		course = courses(:one)
		course.save
		assert_not_nil Course.find_by(courseID: course.courseID), "Did not save the course with valid inputs"
	end

	# Test case to verifying no duplicate courseCode
	def test_double_courseCode
		course = courses(:four)
		dupCourse = courses(:duplicateFour)
		course.save
		assert_not_nil Course.find_by(courseID: course.courseID), "Course one was not saved"
		assert !dupCourse.save, "Duplicated course was saved"
	end

	# Test case for nil values
	def test_nil_values
		course = courses(:nil)
		assert !course.save, "Nil course form saved"
	end

	# Test for endTime earlier than startTime
	def test_endTime_earlier_than_startTime
		course = courses(:four)
		assert !course.save, "Course was saved with endTime earlier than startTime"
	end

	# Test for correct courseId length
	def test_correct_courseID_length
		course = courses(:one)
		assert !course.save, "Course ID with wrong length accepted"
	end

	# Test case for user story 19
        def test_cancel_course
                course = courses(:five)
                Course.find_by(courseID: course.courseID).delete_all
                assert Course.find_by(courseID: course.courseID), "Course is not in Courses database"
        end
end
