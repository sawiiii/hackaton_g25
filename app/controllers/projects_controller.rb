class ProjectsController < ApplicationController
  before_action :authorize
  before_action :validate_current_user, only: [ :create, :update, :destroy ]
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  def index
    # filtro para no mostrar los que estén llenos
    if params[:person_auth0_id].present?
      @person = Person.find_by(auth0_id: params[:person_auth0_id])
      @projects = @person.projects
    else
      @projects = Project.all.with_more_vacancies.not_mine(current_user&.id).includes(:positions)
    end

    render json: @projects.as_json(
      include: {
        positions: {},
        owner: { only: [:name, :auth0_id] }
      }
    )
  end


  # GET /projects/1
  def show
    render json: @project.as_json(
      include: {
        positions: {},
        owner: { only: [:auth0_id] }
      }
    )
  end

  # POST /projects
  def create
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
    if current_user.nil? || current_user&.auth0_id != params[:person_auth0_id]
      render json: { message: "Forbidden" }, status: :forbidden
    end
  end
end
