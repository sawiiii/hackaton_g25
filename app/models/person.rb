class Person < ApplicationRecord

  validates :name, on: :create, presence: true
  validates :auth0_id, on: :create, presence: true
end
