class Todo < ApplicationRecord
  include RelationsHelper

  enum status: {
    completed: 1,
    not_completed: 0
  }

  validates :user_id, presence: true

  belongs_to :user
end
