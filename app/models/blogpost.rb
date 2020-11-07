class Blogpost < ApplicationRecord
  include RelationsHelper

  validates :title, :body, presence: true
  validates :title, uniqueness: true

  has_many :saved_blogposts, dependent: :destroy
  belongs_to :user

  # Returns saved_blogpost, if exists
  def saved_by?(some_user)
    saved_blogposts.find_by(user_id: some_user.id)
  end

  # Returns [blogposts, has_more]
  def self.get_blogposts(limit, user: nil)
    blogposts =
      if user
        self.where(user_id: user.id).limit(limit + 1).
          order(:created_at).reverse_order
      else
        self.limit(limit + 1).order(:created_at).reverse_order
      end

    if blogposts.count > limit
      [blogposts.limit(limit), true]
    else
      [blogposts, false]
    end
  end

  # Determine the quantity of blogposts already displayed when requesting more
  def self.blogposts_displayed(blogposts_per_request, more_counter: 1)
    more_counter.to_i * blogposts_per_request
  end

  # Determine the max limit for total blogposts to be shown after this request
  def self.limit_blogposts(blogposts_per_request, more_counter: 0)
    (1 + more_counter.to_i) * blogposts_per_request
  end
end
