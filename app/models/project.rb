class Project < ApplicationRecord
  belongs_to :owner, class_name: "Person"
  has_many :positions

  validates :name, on: :create, presence: true
  validates :description, on: :create, presence: true
  validates :owner, on: :create, presence: true
end
