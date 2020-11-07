module RelationsHelper
  def created_by?(some_user)
    some_user.id == user.id
  end
end
