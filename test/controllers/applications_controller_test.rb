require "test_helper"

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @application = applications(:one)
  # end
  #
  # test "should get index" do
  #   get applications_url, as: :json, headers: auth_headers
  #   assert_response :success
  # end
  #
  # test "should create application" do
  #   assert_difference("Application.count") do
  #     post applications_url, params: { application: { motivation: @application.motivation } }, as: :json, headers: auth_headers
  #   end
  #
  #   assert_response :created
  # end
  #
  # test "should show application" do
  #   get application_url(@application), as: :json, headers: auth_headers
  #   assert_response :success
  # end
  #
  # test "should update application" do
  #   patch application_url(@application), params: { application: { motivation: @application.motivation } }, as: :json, headers: auth_headers
  #   assert_response :success
  # end
  #
  # test "should destroy application" do
  #   assert_difference("Application.count", -1) do
  #     delete application_url(@application), as: :json, headers: auth_headers
  #   end
  #
  #   assert_response :no_content
  # end
  setup do
    # Setting up test data
    @person = people(:one) # Assuming you have a fixture for people
    @project = projects(:one) # Assuming you have a fixture for projects
    @position = positions(:one) # Assuming you have a fixture for positions
    @application = applications(:one) # Assuming you have a fixture for applications

    # Ensure relationships are valid
    @project.update(owner: @person)
    @position.update(project: @project)
    @application.update(position: @position)
  end

  test "should get index" do
    # Test the index endpoint
    get person_project_position_applications_url(@person.auth0_id, @project.id, @position.id), as: :json, headers: auth_headers
    assert_response :success

    # Parse the JSON response and validate
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.size
  end

  test "should create application" do
    # Test the creation of an application
    assert_difference("Application.count") do
      post person_project_position_applications_url(@person.auth0_id, @project.id, @position.id),
           params: { application: { motivation: "Excited to apply" } }, as: :json, headers: auth_headers
    end

    assert_response :created

    # Validate the created application
    json_response = JSON.parse(response.body)
    assert_equal "Excited to apply", json_response["motivation"]
  end

  test "should show application" do
    # Test showing a specific application
    get person_project_position_application_url(@person.auth0_id, @project.id, @position.id, @application.id), as: :json, headers: auth_headers
    assert_response :success

    # Validate the returned application data
    json_response = JSON.parse(response.body)
    assert_equal @application.motivation, json_response["motivation"]
  end

  test "should update application" do
    # Test updating an application
    patch person_project_position_application_url(@person.auth0_id, @project.id, @position.id, @application.id),
          params: { application: { motivation: "Updated motivation" } }, as: :json, headers: auth_headers
    assert_response :success

    # Validate the update
    @application.reload
    assert_equal "Updated motivation", @application.motivation
  end

  test "should destroy application" do
    # Test destroying an application
    assert_difference("Application.count", -1) do
      delete person_project_position_application_url(@person.auth0_id, @project.id, @position.id, @application.id), as: :json, headers: auth_headers
    end

    assert_response :no_content
  end
end
