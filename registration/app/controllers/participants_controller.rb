class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  # GET /participants
  # GET /participants.json
  def index
    # Find all participants that match search criteria.
    @participants = Participant.search(params[:search])
    # Export all member's information to a csv file.
    @exports = Participant.all
    respond_to do |format|
      format.html
      format.csv { send_data @exports.to_csv }
    end
  end

  # GET /participants/1
  # GET /participants/1.json
  def show
	@enrollments = Enrollment.where(:participantID => @participant.participantID)
  end 

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  # POST /participants.json
  def create
    @participant = Participant.new(participant_params)
    #@participant.password = Devise.friendly_token.first(8)
    respond_to do |format|
      if @participant.save
        #RegistrationMailer.welcome(user, generated_password).deliver
        format.html { redirect_to @participant, notice: 'Participant was successfully created.' }
        format.json { render action: 'show', status: :created, location: @participant }
      else
        format.html { render action: 'new' }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1
  # PATCH/PUT /participants/1.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to @participant, notice: 'Participant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant.destroy
    respond_to do |format|
      format.html { redirect_to participants_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participant
      @participant = Participant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participant_params
      params.require(:participant).permit(:participantID, :fname, :lname, :phone, :expirydate, :dr_note_date, :password, :email, :birthday, :role)
    end
end
