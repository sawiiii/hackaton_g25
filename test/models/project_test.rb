require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should fail save project with invalid attributes" do
    project = Project.new(name: "New Project", description: "Project description")
    assert_not project.save, "Failed to save a valid project"
  end

  test "should save project with right attributes" do
    person = Person.new(name: "John Doe", auth0_id: "auth0_123456")
    project = Project.new(name: "New Project", description: "Project description", owner: person)
    assert project.save, "Saved the project without a name"
  end
end
