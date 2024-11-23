require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
    @person = people(:one)
  end

  test "should create project" do
    assert_difference("Project.count") do
      post projects_url, params: { project: { description: @project.description, name: @project.name, owner_id: @person.id } }, as: :json, headers: auth_headers
    end
    assert_response :created
  end

  test "should show project" do
    get project_url(@project), as: :json, headers: auth_headers
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { description: @project.description, name: @project.name, owner_id: @person.id  } }, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete project_url(@project), as: :json, headers: auth_headers
    end

    assert_response :no_content
  end
end
