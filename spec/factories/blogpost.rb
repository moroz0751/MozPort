# This will guess the Blogpost class
FactoryBot.define do
  blogpost_titles = [
    "Did you know that bananas are radioactive?",
    "What is cherophobia?",
    "How to stop a kangaroo from hopping",
    "Coca-Cola owns a lot of websites with interesting names..."
  ]
  blogpost_bodies = [
    "Each BED (banana equivalent dose) corresponds to 0.1 μSv of ionizing radiation.",
    "Cherophobia is an irrational fear of fun or happiness.",
    "Lift its tail off the ground--then it can't hop.",
    "Coca-Cola owns all website URLs that can be read as ahh, all the way up to 62 h’s!"
  ]

  factory :blogpost do
    sequence(:title, 0) do |n|
      if n < 4
        blogpost_titles[n]
      else
        "#{blogpost_titles[n % 4]} v#{n}"
      end
    end

    sequence(:body, 0)  do |n|
      if n < 4
        blogpost_bodies[n]
      else
        "#{blogpost_bodies[n % 4]} v#{n}"
      end
    end

    user
  end
end
