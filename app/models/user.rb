class User < ApplicationRecord
  class Error < StandardError
  end

  # Include default devise modules. Others available are: :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  # Defines user permission level
  enum access_level: {
    "general_user" => 0,
    "master_admin" => 10
  }

  after_destroy :ensure_master_admin_remains

  validates :avatar, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                     aspect_ratio: :square,
                     size: {
                       less_than: 3.megabytes,
                       message: 'must be less than 3MB'
                     }
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :saved_blogposts, dependent: :destroy
  has_many :blogposts, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_one_attached :avatar

  # Returns user's full name
  def full_name
    "#{first_name} #{last_name}"
  end

  # Checks if the user is a master admin
  def is_master_admin?
    access_level == "master_admin"
  end

  # Builds a blogpost if not already saved
  def build_saved_blogpost(blogpost)
    if !saved_blogposts.find_by(blogpost_id: blogpost.id)
      saved_blogposts.build(blogpost: blogpost)
    end
  end

  private

    def ensure_master_admin_remains
      if User.where(access_level: 10).count.zero?
        raise Error.new "Can't delete the last master admin"
      end
    end
end
