require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = Person.create!(name: "Test User", auth0_id: "12345456")
  end

  test "should get index" do
    get people_url, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should get index with sub" do
    get people_url, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should create person" do
    assert_difference("Person.count") do
      post people_url, params: { person: { name: @person.name, auth0_id: "123456" } }, as: :json, headers: auth_headers
    end

    assert_response :created
  end

  test "should show person" do
    get person_url(@person.auth0_id), as: :json, headers: auth_headers
    assert_response :success
  end

  test "should update person" do
    patch person_url(Person.first), params: { person: { name: Person.first.name } }, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should destroy person" do
    assert_difference("Person.count", -1) do
      delete person_url(@person.auth0_id), as: :json, headers: auth_headers
    end

    assert_response :no_content
  end
end
