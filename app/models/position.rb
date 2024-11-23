class Position < ApplicationRecord

  belongs_to :project
  has_many :applications

  validates :name, on: :create, presence: true

end
