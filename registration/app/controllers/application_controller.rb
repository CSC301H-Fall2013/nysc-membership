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

end
