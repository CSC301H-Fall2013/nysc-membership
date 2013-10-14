require 'test_helper'

class CoursesControllerTest < ActionController::TestCase

  ## Setup to be called before every test
  def setup
    @course = courses(:one)
    @nilCourse = courses(:nil)
  end

  ## Teardown to be Called after every test
  def teardown
    @course = nil
  end


  ## Test case for index method

  def test_index_var
    get(:index)
    assert_not_nil(assigns(:courses))
  end


  ## Test cases for new method

  def test_new_nilCourse_var
    post(:new)
    assert_nil(assigns(:nilCourse), "new is not nil")
  end

  def test_new_course
    put(:new)
    assert_not_nil(assigns(:course), "new is nil")
  end


  ## Test cases for create method

  def test_create_course
    post(:create, course: {courseName: @course.courseName, courseCode: @course.courseCode, instructor: @course.instructor, description: @course.description, intensity: @course.intensity, additional: @course.additional, startDate: @course.startDate, endDate: @course.endDate, startTime: @course.startTime, endTime: @course.endTime, duration: @course.duration, earlybirdPrice: @course.earlybirdPrice, memberPrice: @course.memberPrice, nonmemberPrice: @course.nonmemberPrice })
    assert_not_nil Course.find_by(courseName: "Running")
  end

  def test_create_nilCourse
    post(:create, course: {courseName: @nilCourse.courseName, courseCode: @nilCourse.courseCode, instructor: @nilCourse.instructor, description: @nilCourse.description, intensity: @nilCourse.intensity, additional: @nilCourse.additional, startDate: @nilCourse.startDate, endDate: @nilCourse.endDate, startTime: @nilCourse.startTime, endTime: @nilCourse.endTime, duration: @nilCourse.duration, earlybirdPrice: @nilCourse.earlybirdPrice, memberPrice: @nilCourse.memberPrice, nonmemberPrice: @nilCourse.nonmemberPrice })
    assert_nil Course.find_by(courseName: "")
  end


  ## Test cases for show method

  #For later user stories, not for User Story 17
  #def test_show_course
    # get(:show, :id => @course.id)
    # assert_response(:success)
  #end


  ## Test cases for routing

  def test_route_index_to_courseForm
    assert_routing('courses/new', {:controller => "courses", :action => "new"})
  end

  #For later user stories, not for User Story 17
  #def test_route_courseForm_to_index
    #assert_routing('courses', {:controller => "courses", :action => "index"})
  #end


  ## Test case for search method

  #For later user stories, not for User Story 17
  #def test_search_course
    #   get(:search, :courseName => "Running")
    #   assert_not_nil assigns(:course)
    #   assert_equal courses(:running).courseName, assigns(:course).courseName
    #   assert_valid assigns(:course)
    #   assert_redirected_to(:action => "show")
  #end
end
