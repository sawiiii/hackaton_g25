class Position < ApplicationRecord
  belongs_to :project
  has_many :applications

  validates :name, on: :create, presence: true

  def filtered_vacancies
    applications.where(status: "accepted").count
  end
end
