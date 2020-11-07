FactoryBot.define do
  factory :saved_blogpost do
    user_id       {
      unless User.all.count == 0
        FactoryBot.create(:user)
      end
      User.last.id
    }
    blogpost_id   {
      if Blogpost.all.count == 0
        FactoryBot.create_list(:blogpost, 1, user: User.last)
      end
      Blogpost.last.id
    }
  end
end
