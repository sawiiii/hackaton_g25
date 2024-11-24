class Application < ApplicationRecord

  belongs_to :position, counter_cache: true

  belongs_to :person

  enum :status, [ :pending, :accepted, :rejected, :declined ]
end
