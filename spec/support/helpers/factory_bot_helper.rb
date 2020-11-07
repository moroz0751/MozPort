module FactoryBotHelper
  def user(blogposts: 0, saved_blogposts: 0, todos: 0)
    FactoryBot.create(:user) do |user|
      if saved_blogposts >= blogposts
        FactoryBot.create_list(:blogpost, saved_blogposts, user: user)
        FactoryBot.create_list(:saved_blogpost, saved_blogposts, user: user)
      elsif blogposts > 0 && saved_blogposts > 0
        FactoryBot.create_list(:blogpost, blogposts, user: user)
        FactoryBot.create_list(:saved_blogpost, saved_blogposts, user: user)
      elsif blogposts > 0
        FactoryBot.create_list(:blogpost, blogposts, user: user)
      end

      if todos > 0
        FactoryBot.create_list(:todo, todos, user: user)
      end

      user
    end
  end
end
