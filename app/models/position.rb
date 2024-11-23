class Position < ApplicationRecord

  belongs_to :project

  validates :name, on: :create, presence: true

end
