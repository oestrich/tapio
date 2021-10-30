export interface Post {
  id: number;
  body: string;
  username: string;
  inserted_at: string;
  likes_count: number;
}

const fetchPosts = async (): Promise<Post[]> => {
  let posts = await fetch("/posts", {
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      return response.json();
    })
    .then((collection) => {
      return collection["items"];
    });

  return posts;
};

const createPost = (body: string) => {
  fetch("/posts", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({ body }),
  });
};

const createLike = (post: Post) => {
  const href = `/posts/${post.id}/like`;

  fetch(href, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
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

export { createLike, createPost, fetchPosts };
