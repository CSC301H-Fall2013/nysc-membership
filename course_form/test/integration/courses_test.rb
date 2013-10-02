require 'test_helper'

class CoursesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  fixtures :courses

  def test_get_courses
  	get "/courses"
  	assert_response(:success)

  	get_via_redirect("/courses/new")
  	assert_response(:success)
  end

end
