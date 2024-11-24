class Position < ApplicationRecord
  belongs_to :project
  has_many :applications

  validates :name, on: :create, presence: true

  def has_vacancies_left
    vacancies > applications.where(status: "accepted").count
  end

  def applications_count
    applications.count
  end
end
