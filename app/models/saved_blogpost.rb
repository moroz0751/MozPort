class SavedBlogpost < ApplicationRecord
  include RelationsHelper

  validates :user_id, presence: true
  validates :blogpost_id, presence: true

  belongs_to :blogpost
  belongs_to :user

  # Returns [saved_blogposts, has_more]
  def self.get_saved_blogposts(limit, user: current_user)
    saved_blogposts =
      self.where(user_id: user.id).limit(limit + 1).order(:created_at).
        reverse_order

    if saved_blogposts.count > limit
      [saved_blogposts.limit(limit), true]
    else
      [saved_blogposts, false]
    end
  end
end
