require 'test_helper'

class CourseTest < ActiveSupport::TestCase

	class Course < ActiveRecord::Base
	  	validates_uniqueness_of :courseCode
	  	validates_presence_of :courseName, :instructor, :description, :startDate, :endDate, :startTime, :endTime, :duration, :earlybirdPrice, :memberPrice, :nonmemberPrice
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
		assert_not_nil Course.find_by(courseName: course.courseName), "Did not save the course with valid inputs"
	end

	# Test case to verifying no duplicate courseCode
	def test_double_courseCode
		course = courses(:one)
		dupCourse = courses(:duplicateOne)
		course.save
		assert_not_nil Course.find_by(courseName: course.courseName), "Course one was not saved"
		assert !dupCourse.save, "Duplicated course was saved"
	end

	# Test case for nil values
	def test_nil_values
		course = courses(:nil)
		assert !course.save, "Nil course form saved"
	end

end