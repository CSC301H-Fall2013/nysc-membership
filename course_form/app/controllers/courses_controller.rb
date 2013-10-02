class CoursesController < ApplicationController
	def new
		@course = Course.new
		@courses = Course.find(:all)
	end
	
	def create
		@course = Course.new(user_params)
		if @course.save
			redirect_to new_course_path
		end
	end
	
	def index
		@courses = Course.all
	end
	
	def show
		@course = Course.find(params[:id])
	end
	
	private
	
	def user_params
		params.require(:course).permit(:courseName, :courseCode, :instructor, :description, :intensity, :startDate, :endDate, :startTime, :endTime, :duration, :earlybirdPrice, :membersPrice, :nonmembersPrice, :additional)
	end
end
