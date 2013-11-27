class PaymentNotificationController < ApplicationController
    protect_from_forgery :except => [:create]
  
  def create
    PaymentNotification.create!(:params => params, :cart_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:tx])
  end
  
  
end
