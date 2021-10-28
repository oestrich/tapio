import { Post }  from "./post";
import * as React from "react";
import * as ReactDOM from "react-dom";

document.addEventListener("click", (e) => {
  let target = e.target as HTMLAnchorElement;

  if ("method" in target.dataset) {
    e.preventDefault();
    console.log(target.dataset.method, target.href);

    let form = document.createElement("form");
    form.method = "POST";
    form.action = target.href;

    let method = document.createElement("input");
    method.type = "hidden";
    method.name = "_method";
    method.value = target.dataset.method;

    form.append(method);
    document.body.append(form);
    form.submit();
  }
});

interface Like {
  post_id: number;
}

document.addEventListener("DOMContentLoaded", () => {
  let newPost = (post: Post) => {
    let newPost = document.createElement("li");

    newPost.className = 'my-4 py-4 flex rounded bg-white shadow';

    const reactElement = React.createElement(Post, post);
    ReactDOM.render(reactElement, newPost);

    let list = document.querySelector("#posts");
    list.prepend(newPost);
  };

  let newLike = (like: Like) => {
    let post = document.querySelector(`[data-post-id="${like.post_id}"]`);
    let likeCountElement = post.querySelector(".like-count");
    let likeCount = Number(likeCountElement.innerHTML) + 1;
    likeCountElement.innerHTML = likeCount.toString();
  };

  const eventHandlers = {
    "posts/new": newPost,
    "likes/new": newLike,
  };

  let webSocketURL = document.body.dataset.wsUrl;
  let socket = new WebSocket(webSocketURL);

  socket.onmessage = (e) => {
    const message = JSON.parse(e.data);

    if (eventHandlers[message.event]) {
      const handler = eventHandlers[message.event];

      handler(message.data);
    }
  };

  const createPost = (body: string) => {
    fetch("/posts", {
      method: "POST",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: JSON.stringify({ body })
    });
  };

  const createLike = (href: string) => {
    fetch(href, {
      method: "POST",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: "{}",
    }).then((response) => {
      if (!response.ok) {
        let alert = document.querySelector(".alert-error");
        alert.innerHTML = "You've already liked this!";
        alert.classList.remove("hidden");

        setTimeout(() => {
          alert.classList.add("hidden");
        }, 4000);
      }
    });
  };

  let isShiftPressed = false;

  let postBody = document.querySelector("#post_body");

  if (postBody) {
    postBody.addEventListener("keyup", (e: KeyboardEvent) => {
      if (e.key == "Shift") {
        isShiftPressed = false;
      }
    });

    postBody.addEventListener("keydown", (e: KeyboardEvent) => {
      if (e.key == "Shift") {
        isShiftPressed = true;
      }

      if (e.key == "Enter" && !isShiftPressed) {
        e.preventDefault();
        let target = e.target as HTMLInputElement;

        createPost(target.value);
        target.value = "";
      }
    });
  }

  document.addEventListener("click", (e) => {
    let target = e.target as HTMLAnchorElement;

    if (target.classList.contains("like")) {
      e.preventDefault();
      createLike(target.href);
    }
  });
});
