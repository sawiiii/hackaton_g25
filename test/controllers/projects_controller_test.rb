require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
    @person = Person.create!(name: "Test User", auth0_id: Rails.application.credentials.jwt_token)

    # Create projects for the person
    @project1 = Project.create!(name: "Project 1", description: "Description 1", owner_id: @person.id)
    @project2 = Project.create!(name: "Project 2", description: "Description 2", owner_id: @person.id)

    # Create positions for the projects
    @position1 = Position.create!(name: "Position 1", project: @project1, vacancies: 5, applications_count: 2)
    @position2 = Position.create!(name: "Position 2", project: @project2, vacancies: 2, applications_count: 3)

  end
  #
  # test "should get index with more vacancies filter and no person_auth0_id" do
  #   get projects_url, as: :json, headers: auth_headers
  #
  #   assert_response :success
  #   json_response = JSON.parse(response.body)
  #
  #   # Only include projects with positions having vacancies > applications_count
  #   project_ids = json_response.map { |project| project["id"] }
  #   assert_includes project_ids, @project1.id
  #   refute_includes project_ids, @project2.id
  #   assert_includes project_ids, @other_project.id
  # end
  #
  # test "should get index filtered by person_auth0_id" do
  #   get projects_url, params: { person_auth0_id: @person.auth0_id }, as: :json, headers: auth_headers
  #
  #   assert_response :success
  #   json_response = JSON.parse(response.body)
  #
  #   # Only include the person’s projects with more vacancies
  #   project_ids = json_response.map { |project| project["id"] }
  #   assert_includes project_ids, @project1.id
  #   refute_includes project_ids, @project2.id
  #   refute_includes project_ids, @other_project.id
  # end
  #
  # test "should create project" do
  #   assert_difference("Project.count") do
  #     post projects_url(@person), params: { project: { description: @project.description, name: @project.name, owner_id: @person.id } }, as: :json, headers: auth_headers
  #   end
  #   assert_response :created
  # end

  test "should show project" do
    get project_url(@project), as: :json, headers: auth_headers
    assert_response :success
  end

  # test "should update project" do
  #   patch project_url(@project), params: { project: { description: @project.description, name: @project.name, owner_id: @person.id  } }, as: :json, headers: auth_headers
  #   assert_response :success
  # end
  #
  # test "should destroy project" do
  #   assert_difference("Project.count", -1) do
  #     delete project_url(@project), as: :json, headers: auth_headers
  #   end
  #
  #   assert_response :no_content
  # end
end
