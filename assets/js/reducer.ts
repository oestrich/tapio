import { Like, Post } from "./api";

interface State {
  posts: Post[];
}

interface Action {
  type: string;
  data: any;
}

const setPosts = (state: State, posts: Post[]) => {
  return { ...state, posts };
};

const addPost = (state: State, post: Post) => {
  return { ...state, posts: [post, ...state.posts] };
};

const incrementLike = (state: State, like: Like) => {
  let posts = state.posts.map((post) => {
    if (post.id == like.post_id) {
      post.likes_count += 1;
    }
    return post;
  });

  return { ...state, posts };
};

const reducer = (state: State, action: Action): State => {
  switch (action.type) {
    case "posts":
      return setPosts(state, action.data);

    case "posts/new":
      return addPost(state, action.data);

    case "likes/new":
      return incrementLike(state, action.data);

    default:
      return state;
  }
};

const initialState = { posts: [] };

export { initialState, reducer };
