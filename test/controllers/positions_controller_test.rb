require "test_helper"

class PositionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @position = positions(:one)
    @project = projects(:one)
  end

  test "should get index" do
    get project_positions_path(@project), as: :json, headers: auth_headers
    assert_response :success
  end

  test "should create position" do
    assert_difference("Position.count") do
      post project_positions_path(@project), params: { position: { description: @position.description, name: @position.name, vacancies: @position.vacancies } }, as: :json, headers: auth_headers
    end

    assert_response :created
  end

  test "should show position" do
    get project_position_path(@project, @position), as: :json, headers: auth_headers
    assert_response :success
  end

  test "should update position" do
    patch project_position_path(@project, @position), params: { position: { description: @position.description, name: @position.name, vacancies: @position.vacancies } }, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should destroy position" do
    assert_difference("Position.count", -1) do
      delete project_position_path(@project, @position), as: :json, headers: auth_headers
    end

    assert_response :no_content
  end
end
