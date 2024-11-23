require "test_helper"

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save person with valid attributes" do
    person = Person.new(name: "John Doe")
    assert person.save, "Failed to save a valid person"
  end

  test "should not save person without a name" do
    person = Person.new
    assert_not person.save, "Saved the person without a name"
  end
end
