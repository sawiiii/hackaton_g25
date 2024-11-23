class PeopleController < ApplicationController

  before_action :authorize
  before_action :set_person, only: %i[ show update destroy ]

  # GET /people
  def index
    if params[:sub].present?
      person = Person.find_by(auth0_id: params[:sub])
      if person
        render json: [person], status: :ok
      else
        render json: [], status: :ok
      end
    else
      @people = Person.all
      render json: @people
    end
  end


  # GET /people/1
  def show
    render json: @person
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      render json: @person, status: :created, location: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      render json: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      if params[:auth0_id].present?
        @person = Person.find_by(auth0_id: params.expect(:auth0_id))
      end
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.expect(person: [ :name, :auth0_id ])
    end
end
