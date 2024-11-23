require "test_helper"

class PositionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save position with valid attributes" do
    project = Project.create!(name: "New Project", description: "Project description", owner: Person.create!(name: "John Doe", auth0_id: "auth0_123456"))
    position = Position.new(name: "Developer", project: project)
    assert position.save, "Failed to save a valid position"
  end

  test "should not save position without a title" do
    project = Project.create!(name: "New Project", description: "Project description", owner: Person.create!(name: "John Doe", auth0_id: "auth0_123456"))
    position = Position.new(project: project)
    assert_not position.save, "Saved the position without a title"
  end

  test "should not save position without a project" do
    position = Position.new(name: "Developer")
    assert_not position.save, "Saved the position without a project"
  end
end
