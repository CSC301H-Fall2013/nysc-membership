class MemberenrollmentsController < ApplicationController
  def index
  	  @memberenrollments = Enrollment.search(params[:search])
  	  @participants = Participant.search(params[:search])
  end

  # GET /memberenrollments/new
  def new
    session[:memberenrollment_params] ||= {}
    @memberenrollment = Enrollment.new(session[:memberenrollment_params])
    @memberenrollment.current_step = session[:memberenrollment_step]
  end

  # POST /memberenrollments
  # POST /memberenrollments.json
  def create
    session[:memberenrollment_params].deep_merge!(params[:memberenrollment]) if params[:memberenrollment]
    @memberenrollment = Enrollment.new(session[:memberenrollment_params])
    @memberenrollment.current_step = session[:memberenrollment_step]
    if @memberenrollment.valid?
      if params[:back_button]
        @memberenrollment.previous_step
      # if last step, we want to save
      elsif @memberenrollment.last_step?
        # also zero out the price because we know the member has paid for sure
        @memberenrollment.waitlist_price = 0
        @memberenrollment.waitlist_status = @memberenrollment.waitlist_generate
        @memberenrollment.startDate = @memberenrollment.get_start_date
        @memberenrollment.save
      # if first step, check if PARQ is necessary
      elsif @memberenrollment.first_step?
        if @memberenrollment.check_fitness
          # PARQ is necessary, go to step 2
          @memberenrollment.next_step
        else
          @memberenrollment.waitlist_price = @memberenrollment.charge_fee
          # PARQ is not necessary, check if waitlisted
          @memberenrollment.waitlist_status = @memberenrollment.waitlist_generate
          @memberenrollment.startDate = @memberenrollment.get_start_date
          if @memberenrollment.waitlist_status > 0
            # waitlisted
            flash[:warning] = "The class is full, you have been added onto the waitlist as number #{@enrollment.waitlist_status}. " +
            "Please pay at time of successful registration, if necessary."
            @memberenrollment.save if @memberenrollment.all_valid?
          else
            # not waitlisted - just go to step 3 and display the price to pay
            @memberenrollment.next_step
            @memberenrollment.next_step
          end
        end
      # step 2
      elsif @memberenrollment.steps[1]
        @memberenrollment.waitlist_status = @memberenrollment.waitlist_generate
        @memberenrollment.waitlist_price = @memberenrollment.charge_fee
        @memberenrollment.startDate = @memberenrollment.get_start_date
        if @memberenrollment.waitlist_status > 0
          # waitlisted... don't pay yet
          flash[:warning] = "The class is full, you have been added onto the waitlist as number #{@enrollment.waitlist_status}. " +
          "Please pay at time of successful registration, if necessary."
          @memberenrollment.save if @memberenrollment.all_valid?
        else
          @memberenrollment.next_step
        end
      end
      session[:memberenrollment_step] = @memberenrollment.current_step
    end
    if @memberenrollment.new_record?
      render "new"
    else
      session[:memberenrollment_step] = session[:memberenrollment_params] = nil
      flash[:notice] = "Enrollment saved!"
      redirect_to @memberenrollment
    end
  end

end
