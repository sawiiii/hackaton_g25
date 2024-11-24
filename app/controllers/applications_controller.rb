class ApplicationsController < ApplicationController
  before_action :authorize
  before_action :set_application, only: %i[ show update destroy change_status ]
  before_action :validate_current_user, only: [ :user_application, :user_applications ]

  # GET /applications
  def index
    if params.expect(:position_id)
      @position = Position.find(params.expect(:position_id))
      @applications = @position.applications
    else
      @applications = Application.all
    end

    render json: @applications
  end

  # GET /applications/1
  def show
    render json: @application
  end

  # POST /applications
  def create
    if !current_user
      return render json: {}, status: :unauthorized
    end
    set_position
    if @position.project.owner == current_user
      puts "You cannot apply to positions in your own project"
      return render json: { error: "You cannot apply to positions in your own project" }, status: :forbidden
    end

    ids = @position.applications.pluck(:person_id)

    if ids.include?(current_user.id)
      puts "You cannot apply to the same position more than once"
      return render json: { error: "You cannot apply to the same position more than once" }, status: :forbidden
    end

    accepted = @position.applications.where(status: "accepted").count
    if accepted >= @position.vacancies
      puts "Position is already full"
      return render json: { error: "Position is already full" }, status: :bad_request
    end

    # validar posiciones
    #
    @application = Application.new(application_params)
    @application.position = @position
    @application.person = current_user

    if @application.save
      render json: @application, status: :created
    else
      raise StandardError.new(@application.errors.full_messages.join(", "))
    end
  rescue => e
    puts e.full_message
    render json: {error: e}, status: :unprocessable_entity
  end

  # PATCH/PUT /applications/1
  def update
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/1
  def destroy
    @application.destroy!
  end

  def change_status
    allowed_statuses = nil
    if @application.position.project.owner == current_user
      allowed_statuses = [ "accepted", "rejected" ]
    elsif @application.person == current_user
      allowed_statuses = [ "declined" ]
    end

    # si el estado quiere ser aceptado y ya esta el maximo se rechaza
    if application_params_status[:status].present? && application_params_status[:status] == "accepted"
      position =  @application.position
      accepted_applications_count = position.applications.where(status: "accepted").count
      #puts "accepted_applications_count: #{accepted_applications_count} - position.vacancies: #{position.vacancies}"
      if accepted_applications_count >= position.vacancies || check_if_is_on_project(@application)
        return render json: { error: "Position is already full or you cannot be again on the same project" }, status: :forbidden
      end
    end

    if allowed_statuses.present? && allowed_statuses.include?(application_params_status[:status])
      if @application.update(application_params_status)
        if @application.status == "accepted"
          add_member_to_project(@application)
        end
        render json: { message: "Status updated successfully", application: @application }, status: :ok
      else
        render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Status is not allowed" }, status: :forbidden
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def user_applications
    @applications = current_user.applications
    render json: @applications.as_json(
      include: {
        position: {}
      }
    )
  end

  def user_application
    @application = current_user.applications.find(params[:id])
    render json: @application.as_json(
      include: {
        position: {}
      }
    )
  end

  private

  def check_if_is_on_project(application)
    position = application.position
    project = position.project
    project.members.include?(application.person)
  end

  def add_member_to_project(application)
    position = application.position
    project = position.project

    accepted_applications_count = position.applications.where(status: "accepted").count

    #puts "accepted_applications_count: #{accepted_applications_count} - position.vacancies: #{position.vacancies}"
    if accepted_applications_count <= position.vacancies
      project.members << application.person unless project.members.include?(application.person)
    else
      raise "Cannot add more members to the project. Position vacancies are full."
    end
  end

  def set_position
    @position = Position.find(params[:position_id])
  end

  def set_application
    @application = Application.find(params.expect(:id))
  end

  def application_params
    params.require(:application).permit(:motivation)
  end

  def application_params_status
    params.require(:application).permit(:status)
  end

  def validate_current_user
    if current_user.nil? || current_user&.auth0_id != params[:person_id]
      render json: { message: "Forbidden" }, status: :forbidden
    end
  end
end
