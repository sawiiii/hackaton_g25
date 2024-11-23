class Person < ApplicationRecord

  validates :name, on: :create, presence: true
end
