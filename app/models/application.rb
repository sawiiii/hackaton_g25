class Application < ApplicationRecord
  belongs_to :position
  belongs_to :person

  enum :status, [ :pending, :accepted, :rejected ]
end
