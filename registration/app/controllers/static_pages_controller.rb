class StaticPagesController < ApplicationController
  def participanthome
  	@course = Enrollment.where(:participantID => current_participant.participantID)
  end

  def check_participant
    @participant = Participant.find_by_id(params[:id])
    # Then you can access the teachers with @school.teachers
  end

end
