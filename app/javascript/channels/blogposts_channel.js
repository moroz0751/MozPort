import consumer from "./consumer"

consumer.subscriptions.create("BlogpostsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const blogpostDiv = document.getElementById("blogpost-" + data.blogpost.id)
    if (blogpostDiv) {
      blogpostDiv.innerHTML = data.html
    }
  }
});
