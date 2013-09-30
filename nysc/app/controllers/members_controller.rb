class MembersController < ApplicationController
  def index

  end

  def new
  	@member = Member.new
  end

  def create
  	@member = Member.new(params[:member])

  	if @member.save
  		redirect_to members_path, :notice => "Your Membership was Created"
  	else
  		render "new"
  	end
  end

end
