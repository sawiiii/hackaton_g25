class ProjectsController < ApplicationController
  before_action :authorize
  before_action :validate_current_user, only: [ :create, :update, :destroy ]
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  def index
    tag = Category.where(name: params[:tag]) if params[:tag].present?
    if params[:person_auth0_id].present?
      @person = Person.find_by(auth0_id: params[:person_auth0_id])
      if params[:owner].present?
        if params[:owner] == "true"
          @projects = @person.projects || []
        end
      else
        @projects = @person.member_projects || []
      end
    else
      @projects = Project.all.with_more_vacancies_v2.not_mine(current_user&.id).includes(:positions) || []
    end

    if tag&.present?
      @projects = @projects&.joins(:categories)&.where(categories: tag)
    end

    render json: @projects.as_json(
      include: {
        positions: {},
        categories: { only: [ :name ] },
        owner: { only: [ :name, :auth0_id ] }
      }
    )
  end


  # GET /projects/1
  def show
    # Fetch the project including its positions with their applications
    @project = Project.includes(positions: :applications).find(params[:id])

    # Filter positions for the project based on the condition
    filtered_positions = @project.positions.select do |position|
      position.vacancies > position.applications.where(status: "accepted").count
    end

    data = @project.as_json(
      include: {
        positions: {
          only: [ :id, :name, :description, :vacancies ],
          methods: [ :has_vacancies_left, :applications_count ],
          objects: filtered_positions
        },
        categories: { only: [ :name ] },
        owner: {
          only: [ :auth0_id ]
        }
      }
    )

    if @project.owner == @current_user
      applications = JSON.parse(@project.positions.map(&:applications).flatten.to_json include: :person)
      data[:applications] = applications
    end

    render json: data
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.owner = @current_user

    if @project.save
      tags = GenerateLabelsService.new(@project&.description).call
      tags&.each do |category_name|
        ProjectCategory.create!(project: @project, category: Category.find_by(name: category_name))
      end
      render json: @project.as_json(
        include: {
          positions: {},
          categories: { only: [ :name ] },
          owner: { only: [ :name, :auth0_id ] }
        }
      ), status: :created, location: @project
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
