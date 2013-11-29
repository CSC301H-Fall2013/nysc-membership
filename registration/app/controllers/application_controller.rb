class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Check to see if login corresponds to a participant.
  before_filter :authenticate_participant!

  # Render the admin, or participant homepage 
  # depending on user role.
  def after_sign_in_path_for(participant)
    if participant.admin?
    	static_pages_adminhome_path
    else 
    	static_pages_participanthome_path
    end
  end

  def current_cart
    if session[:cart_id]
      @current_cart ||= Cart.find(session[:cart_id])
      session[:cart_id] = nil if @current_cart.purchased_at
    end
    if session[:cart_id].nil?
      @current_cart = Cart.create!
      session[:cart_id] = @current_cart.id
    end
    @current_cart
end

  # layout based on signin
  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :participant && action_name == 'new'
      "devise"
    else
      "application"
    end
  end
  
  
end
