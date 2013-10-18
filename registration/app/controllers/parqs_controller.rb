class ParqsController < ApplicationController
  before_action :set_parq, only: [:show, :edit, :update, :destroy]

  # GET /parqs
  # GET /parqs.json
  def index
    @parqs = Parq.all
  end

  # GET /parqs/1
  # GET /parqs/1.json
  def show
  end

  # GET /parqs/new
  def new
    @parq = Parq.new
  end

  # GET /parqs/1/edit
  def edit
  end

  # POST /parqs
  # POST /parqs.json
  def create
    @parq = Parq.new(parq_params)

    respond_to do |format|
      if @parq.save
        format.html { redirect_to @parq, notice: 'Parq was successfully created.' }
        format.json { render action: 'show', status: :created, location: @parq }
      else
        format.html { render action: 'new' }
        format.json { render json: @parq.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parqs/1
  # PATCH/PUT /parqs/1.json
  def update
    respond_to do |format|
      if @parq.update(parq_params)
        format.html { redirect_to @parq, notice: 'Parq was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @parq.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parqs/1
  # DELETE /parqs/1.json
  def destroy
    @parq.destroy
    respond_to do |format|
      format.html { redirect_to parqs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parq
      @parq = Parq.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parq_params
      params.require(:parq).permit(:participantID, :courseID, :startDate, :disclaimer, :ans1, :ans2, :ans3, :ans4, :ans5, :ans6, :ans7)
    end
end
