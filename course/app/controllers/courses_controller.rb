class CoursesController < ApplicationController
	def new
		# Create a new instance variable when creting a new course to store the values
		@course = Course.new

		# Create a new instance variable to hold on all the coures currently in the database
		# @courses = Course.find(:all)
	end
	
	def create
		@course = Course.new(user_params)

		# If the user entered submit, store the newly created course in the database
		if @course.save
			redirect_to courses_path, :notice => "Your Post was Saved"
		else
			render "new"
		end
	end
	
	def index
		# Create an instance varialb to display all the courses in the main page
		@courses = Course.all
	end
	
	def show
		# Create an instance varialbe to display each course indivudually by its uniquie id
		@course = Course.find(params[:id])
	end
	
	private
	
	# Create a local varibale to store all the parameters passed by in the user when inputting data to create a new course
	def user_params
		params.require(:course).permit(:courseName, :courseCode, :instructor, :description, :intensity, :startDate, :endDate, :startTime, :endTime, :duration, :earlybirdPrice, :memberPrice, :nonmemberPrice, :additional)
	end
end
