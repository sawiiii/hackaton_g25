class ProjectsController < ApplicationController

  before_action :authorize
  #before_action :validate_current_user
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  def index
    if params.expect(:person_auth0_id)
      @person = Person.find_by(auth0_id: params.expect(:person_auth0_id))
      @projects = @person.projects
    else
      @projects = Project.all
    end

    render json: @projects
  end

  # GET /projects/1
  def show
    render json: @project
  end

  # POST /projects
  def create
    @current_user = Person.first
    @project = Project.new(project_params)
    @project.owner = @current_user

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :name, :description, :owner_id ])
    end

    def validate_current_user
      if current_user.nil?
        render json: { message: "Unauthorized" }, status: :unauthorized
      end
    end
end
