class BlogpostsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "blogposts"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
