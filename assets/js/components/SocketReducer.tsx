import * as React from "react";
import { useEffect, useReducer } from "react";

import { fetchPosts, Like, Post } from "../api";
import { initialState, reducer } from "../reducer";
import { useWebsocket, SocketContext } from "../websocket";
import { PostsContext } from "./Posts";

export interface SocketReducerProps {
  webSocketURL: string;
}

export function SocketReducer({ webSocketURL, children }: React.PropsWithChildren<SocketReducerProps>) {
  const [state, dispatch] = useReducer(reducer, initialState);

  useEffect(() => {
    fetchPosts().then((posts) => {
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
      <PostsContext.Provider value={state.posts}>{children}</PostsContext.Provider>
    </SocketContext.Provider>
  );
}
