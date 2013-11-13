class WaitlistController < ApplicationController
	before_action :set_waitlist, only: [:show, :edit, :update, :destroy]
  # GET /waitlist
  # GET /waitlist.json
  def index
  end
  
  # GET /waitlist/1
  # GET /waitlist/1.json
  def show
      @enrollments = Enrollment.where(:courseID => @course.courseID, :startDate => @course.startDate).where(['enrollments.waitlist_status <> ?', 0])
  end
  
  # GET /waitlist/new
  def new
  end
  
  # GET /waitlist/1/edit
  def edit
  end
  
  # POST /waitlist
  # POST /waitlist.json
  def create
  end
  
  # PATCH/PUT /waitlist/1
  # PATCH/PUT /waitlist/1.json
  def update
  end
  
  # DELETE /waitlist/1
  # DELETE /waitlist/1.json
  def destroy
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waitlist
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:courseID, :startDate, :title, :instructor, :description, :intesity, :additional, :duration, :startTime, :endTime, :dayOfWeek, :earlybirdPrice, :memberPrice, :nonmemberPrice, :size)
    end  
end
