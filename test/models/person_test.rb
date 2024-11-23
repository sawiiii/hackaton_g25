require "test_helper"

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save person without valid attributes auth0_id" do
    person = Person.new(name: "John Doe")
    assert_not person.save, "Failed to save a valid person"
  end

  test "should not save person without a name" do
    person = Person.new
    assert_not person.save, "Saved the person without a name"
  end

  test "should  save person with a auth0" do
    person = Person.new(name: "John Doe", auth0_id: "auth0_123456")
    assert person.save, "Saved the person without a name"
  end
end
