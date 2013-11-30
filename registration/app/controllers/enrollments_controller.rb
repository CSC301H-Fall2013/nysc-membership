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
    @payback = Enrollment.where("refund_back > ?", 0)
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
        # check if the person processing the enrollment is a member or admin
        if current_participant.role?
          # also zero out the price because we know the member has paid since the admin is handling it
          @enrollment.price_owed = 0
          @enrollment.price_paid = @enrollment.charge_fee
          @enrollment.waitlist_status = @enrollment.waitlist_generate
          @enrollment.startDate = @enrollment.get_start_date
          @enrollment.refund_back = 0
          @enrollment.save
        else
          # make it such that price_owed has the amount to be charged, do not change until we know they paid
          @enrollment.price_owed = @enrollment.charge_fee
          @enrollment.refund_back = 0
          @enrollment.price_paid = 0
          @enrollment.waitlist_status = @enrollment.waitlist_generate
          @enrollment.startDate = @enrollment.get_start_date
          # save the enrollment object in the session, do not add it to database until payment notification is received
          session[:enroll_save] = @enrollment
          @enrollment.updatepayment
          # redirect to paypal website
          redirect_to paypal_url(static_pages_participanthome_url, @paymentnotification_create_url)
        end
      # if first step, check if PARQ is necessary
      elsif @enrollment.first_step?
        if @enrollment.check_fitness
          # PARQ is necessary, go to step 2
          @enrollment.next_step
        else
          @enrollment.price_paid = 0
          @enrollment.refund_back = 0
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
        @enrollment.refund_back = 0 
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
      if @enrollment.is_payment?
        render "new"
      end
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

    # Constructs the enrollment paypal url with the appropriate query values to pass to the website
    def paypal_url(return_url, notify_url)
      # take the enrollment object from session to use for processing paypal payment
      @enrollment = session[:enroll_save]
        values = {
          # specify business account used for selling, seller@nysc.com is a developer account
          :business => 'seller@nysc.com',
          # shopping cart was chosen as the payment type, later developers can expand this so members can pay for multiple classes at once
          :cmd => '_cart',
          :upload => 1,
          # pass url that paypal redirects to after payment 
          :return => return_url,
          # a unique identifier used for the invoice number otherwise paypal will tell members they have paid already after that invoice id is paid for once
          :invoice => @enrollment.id,
          # ensures the person is paying in CAD instead of the default currency, USD
          :currency_code => 'CAD',
          :amount_1 => @enrollment.price_owed,
          :item_name_1 => @enrollment.courseID,
          :item_number_1 => @enrollment.courseID,
          # quantity remains as 1 because members can only enroll themselves in the class 
          :quantity_1 => '1',
          # url that paypal should send notification to when payment has processed successfully
          :notify_url => notify_url
        }
        # use https://www.sandbox.paypal.com for test payments with dummy account, switch to https://www.paypal.com for real payments
        "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
    end
end
