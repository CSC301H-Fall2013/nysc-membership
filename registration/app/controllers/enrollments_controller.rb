class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]

  # GET /enrollments
  # GET /enrollments.json
  def index
    @enrollments = Enrollment.search(params[:search])
    
    #Showing courses that are availabe for that certain season
    start_date = Enrollment.get_season
    end_date = Enrollment.get_season + 2.month
    @availableCourses = Course.where(:startDate => start_date..end_date)
  end

  # GET /enrollments/1
  # GET /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    session[:enrollment_params] ||= {}
    @enrollment = Enrollment.new(session[:enrollment_params])
    @enrollment.current_step = session[:enrollment_step]
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments
  # POST /enrollments.json
  def create
    session[:enrollment_params].deep_merge!(params[:enrollment]) if params[:enrollment]
    @enrollment = Enrollment.new(session[:enrollment_params])
    @enrollment.current_step = session[:enrollment_step]
    if @enrollment.valid?
      if params[:back_button]
        @enrollment.previous_step
      # if last step, we want to save
      elsif @enrollment.last_step?
        # also zero out the price because we know the member has paid for sure
        @enrollment.price_owed = 0
        @enrollment.price_paid = @enrollment.charge_fee
        @enrollment.waitlist_status = @enrollment.waitlist_generate
        @enrollment.startDate = @enrollment.get_start_date
        @enrollment.save
      # if first step, check if PARQ is necessary
      elsif @enrollment.first_step?
        if @enrollment.check_fitness
          # PARQ is necessary, go to step 2
          @enrollment.next_step
        else
          @enrollment.price_paid = 0
          @enrollment.price_owed = @enrollment.charge_fee
          # PARQ is not necessary, check if waitlisted
          @enrollment.waitlist_status = @enrollment.waitlist_generate
          @enrollment.startDate = @enrollment.get_start_date
          if @enrollment.waitlist_status > 0
            # waitlisted
            flash[:warning] = "The class is full, you have been added onto the waitlist as number #{@enrollment.waitlist_status}. " +
            "Please pay at time of successful registration, if necessary."
            @enrollment.save if @enrollment.all_valid?
          else
            # not waitlisted - just go to step 3 and display the price to pay
            @enrollment.next_step
            @enrollment.next_step
          end
        end
      # step 2
      elsif @enrollment.steps[1]
        @enrollment.waitlist_status = @enrollment.waitlist_generate
        @enrollment.price_paid = 0 
        @enrollment.price_owed = @enrollment.charge_fee
        @enrollment.startDate = @enrollment.get_start_date
        if @enrollment.waitlist_status > 0
          # waitlisted... don't pay yet
          flash[:warning] = "The class is full, you have been added onto the waitlist as number #{@enrollment.waitlist_status}. " +
          "Please pay at time of successful registration, if necessary."
          @enrollment.save if @enrollment.all_valid?
        else
          @enrollment.next_step
        end
      end
      session[:enrollment_step] = @enrollment.current_step
    end
    if @enrollment.new_record?
      render "new"
    else
      session[:enrollment_step] = session[:enrollment_params] = nil
      flash[:notice] = "Enrollment saved!"
      redirect_to @enrollment
    end
  end

  # PATCH/PUT /enrollments/1
  # PATCH/PUT /enrollments/1.json
  def update
    @enrollment = Enrollment.find(params[:id])
    @enrollment.price_paid = @enrollment.price_owed
    @enrollment.price_owed = 0
    @enrollment.waitlist_status = 0
    if @enrollment.update_attributes(params[:enrollment])
       redirect_to :action => 'show', :id => @enrollment
       flash[:warning] = "You have been removed from the waitlist and enrolled into the course. Thank you for paying!"
    else
       render :action => 'edit'
    end
  end


  # DELETE /enrollments/1
  # DELETE /enrollments/1.json
  def destroy
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enrollment_params
      params.fetch(:enrollment).permit(:participantID, :courseID, :startDate, :waitlist_status, :price_paid, :price_owed, :ans1, :ans2, :ans3, :ans4, :ans5, :ans6, :ans7)
    end
end
