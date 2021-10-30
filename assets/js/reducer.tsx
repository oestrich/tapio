import * as React from "react";
import {  useEffect, useReducer } from "react";

import { fetchPosts, Post, PostsContext }  from "./posts";
import { useWebsocket, SocketContext } from "./websocket";

export interface SocketReducer {
  webSocketURL: string;
}

interface Like {
  post_id: number;
}

interface State {
  posts: Post[];
}

interface Action {
  type: string;
  data: any;
}

const initialState = {posts: []};

const setPosts = (state: State, posts: Post[]) => {
  return {...state, posts};
};

const addPost = (state: State, post: Post) => {
  return {...state, posts: [post, ...state.posts]};
};

const incrementLike = (state: State, like: Like) => {
  let posts = state.posts.map((post) => {
    if (post.id == like.post_id) {
      post.likes_count += 1;
    }
    return post;
  });

  return {...state, posts};
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
}

export function SocketReducer({ webSocketURL, children }: React.PropsWithChildren<SocketReducer>) {
  const [state, dispatch] = useReducer(reducer, initialState);

  useEffect(() => {
    fetchPosts()
      .then((posts) => {
        dispatch({ type: "posts", data: posts });
      });
  }, []);

  const newPost = (post: Post) => {
    dispatch({ type: "posts/new", data: post });
  };

  const newLike = (like: Like) => {
    dispatch({ type: "likes/new", data: like });
  };

  const socket = useWebsocket(webSocketURL, {
    "posts/new": newPost,
    "likes/new": newLike,
  });

  return (
    <SocketContext.Provider value={socket}>
      <PostsContext.Provider value={state.posts}>
        {children}
      </PostsContext.Provider>
    </SocketContext.Provider>
  );
}
