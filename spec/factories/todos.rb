FactoryBot.define do
  factory :todo do
    user_id   {
      unless User.all.count == 0
        FactoryBot.create(:user)
      end
      User.last.id
    }
    task      { "Conquer the world" }
  end
end
