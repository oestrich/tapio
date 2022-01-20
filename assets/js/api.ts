import axios from "axios";

export interface Post {
  id: number;
  body: string;
  username: string;
  inserted_at: string;
  likes_count: number;
}

export interface Like {
  post_id: number;
}

const fetchPosts = async (): Promise<Post[]> => {
  let posts = await axios({
    method: "GET",
    url: "/posts",
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      return response.data;
    })
    .then((collection) => {
      return collection["items"];
    });

  return posts;
};

const createPost = async (body: string): Promise<boolean> => {
  return await axios({
    url: "/posts",
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    data: JSON.stringify({ body }),
  })
    .then(() => true)
    .catch(() => false);
};

const createLike = async (post: Post): Promise<boolean> => {
  const href = `/posts/${post.id}/like`;

  return await axios({
    url: href,
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    data: "{}",
  })
    .then((response) => response.status == 201)
    .catch(() => false);
};

export { createLike, createPost, fetchPosts };
