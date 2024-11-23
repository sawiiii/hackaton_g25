require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get people_url, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should not create person" do
    assert_difference("Person.count") do
      post people_url, params: { person: { name: @person.name } }, as: :json, headers: auth_headers
    end

    assert_response :created
  end

  test "should show person" do
    get person_url(@person), as: :json, headers: auth_headers
    assert_response :success
  end

  test "should update person" do
    patch person_url(@person), params: { person: { name: @person.name } }, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should destroy person" do
    assert_difference("Person.count", -1) do
      delete person_url(@person), as: :json, headers: auth_headers
    end

    assert_response :no_content
  end
end
