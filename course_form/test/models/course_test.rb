require 'test_helper'

class CourseTest < ActiveSupport::TestCase

  class Course < ActiveRecord::Base
  	validates_uniqueness_of :courseCode
  	validates_presence_of :courseName, :instructor, :description, :startDate, :endDate, :startTime, :endTime, :duration, :earlybirdPrice, :memberPrice, :nonmemberPrice
  end

  def test_course_should_not_save
  	course = Course.new
  	assert !course.save, "Saved the course without required inputs"
  end

  def test_create_save
  	course = courses(:one)
  	assert course.save, "Did not save the course with valid inputs"
  end

  def test_double_courseCode
  	# course = courses(:one)
  	# dupCourse = courses(:duplicateOne)
  	# assert course.save, "Course one is not saved"
  	# assert !course.save, "Duplicated course was saved"
  end

  def test_nil_values
  	course = courses(:nil)
  	assert !course.save, "Nil course form saved"
  end

end