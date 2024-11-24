class PositionsController < ApplicationController
  before_action :set_position, only: %i[ show update destroy ]

  # GET /positions
  def index
    if params.expect(:project_id)
      @project = Project.find(params.expect(:project_id))
      @positions = @project.positions
    else
      @positions = Position.all
    end

    render json: @positions
  end

  # GET /positions/1
  def show
    render json: @position
  end

  # POST /positions
  def create
    set_project
    @position = Position.new(position_params)
    @position.project = @project

    if @position.save
      render json: @position, status: :created, location: @position
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /positions/1
  def update
    if @position.update(position_params)
      render json: @position
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # DELETE /positions/1
  def destroy
    @position.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params.expect(:id))
    end

    def set_project
      @project = Project.find(params.expect(:project_id))
    end

    # Only allow a list of trusted parameters through.
    def position_params
      params.require(:position).permit(:name, :description, :vacancies)
    end
end
