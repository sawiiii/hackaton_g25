class Project < ApplicationRecord

  belongs_to :owner, class_name: 'Person'
  has_many :positions

  validates :name, on: :create, presence: true
  validates :description, on: :create, presence: true
  validates :owner, on: :create, presence: true

  scope :with_more_vacancies, -> {
    joins(:positions)
      .where('positions.vacancies > positions.applications_count')
      .distinct
  }

  scope :not_mine, ->(id) { where('owner_id != ?', id) }
end
