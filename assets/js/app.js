document.addEventListener("click", (e) => {
  let target = e.target;

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

document.addEventListener("DOMContentLoaded", () => {
  let newPost = (post) => {
    let newPost = document.createElement("li");
    newPost.className = 'my-4 py-4 flex rounded bg-white shadow';

    newPost.innerHTML = `
    <div class="mx-3 w-full" data-post-id="${post.id}">
      <p class="">${post.body}</p>

      <div class="flex flex-row justify-between w-full">
        <div class="text-sm text-gray-400">
          <span class="text-green-600">${post.username}</span> at ${post.inserted_at}
        </div>
        <div>
          <span class="like-count">0</span>
          <a href="/posts/${post.id}/like" class="like text-sm">Like</a>
        </div>
      </div>
    </div>
    `;

    let list = document.querySelector("#posts");
    list.prepend(newPost);
  };

  let newLike = (like) => {
    let post = document.querySelector(`[data-post-id="${like.post_id}"]`);
    let likeCountElement = post.querySelector(".like-count");
    let likeCount = Number(likeCountElement.innerHTML) + 1;
    likeCountElement.innerHTML = likeCount;
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

  const createPost = (body) => {
    fetch("/posts", {
      method: "POST",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: JSON.stringify({ body })
    });
  };

  const createLike = (href) => {
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
    postBody.addEventListener("keyup", (e) => {
      if (e.key == "Shift") {
        isShiftPressed = false;
      }
    });

    postBody.addEventListener("keydown", (e) => {
      if (e.key == "Shift") {
        isShiftPressed = true;
      }

      if (e.key == "Enter" && !isShiftPressed) {
        e.preventDefault();
        createPost(e.target.value);
        e.target.value = "";
      }
    });
  }

  document.addEventListener("click", (e) => {
    let target = e.target;
    if (target.classList.contains("like")) {
      e.preventDefault();
      createLike(target.href);
    }
  });
});
