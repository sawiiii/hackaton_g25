class ApplicationsController < ApplicationController

  before_action :authorize
  before_action :set_application, only: %i[ show update destroy ]
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
    if current_user
      render json: {}, status: :unauthorized
    end
    set_position
    @application = Application.new(application_params)
    @application.position = @position
    @application.person = current_user

    if @application.save
      render json: @application, status: :created, location: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
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

  def set_position
    @position = Position.find(params[:position_id])
  end
    # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find(params.expect(:id))
  end

    # Only allow a list of trusted parameters through.
  def application_params
    params.expect(application: [ :motivation ])
  end

  def validate_current_user
    puts "current_user: #{current_user}"
    if current_user.nil? || current_user&.auth0_id != params[:person_id]
      render json: { message: "Forbidden" }, status: :forbidden
    end
  end
end
