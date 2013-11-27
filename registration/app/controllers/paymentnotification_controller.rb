class PaymentnotificationController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    @notification = PaymentNotification.new
    @notification.transaction_id = params[:ipn_track_id]
    @notification.params = params
    @notification.status = "paid"
    @custom = Base64.decode64(params[:custom])
    @custom = @custom.split("|")
    @user = User.new
    @user.email = @custom[0]
    @user.organization_type_id = @custom[1].to_i
    @user.password = @custom[2]
    if @user.valid?
      @user.save
      @notification.user = @user
      @notification.save
      @user.send_confirmation_instructions
    end
    render :nothing => true
  end
  
end
