import * as React from "react";
import { useEffect, useReducer } from "react";

import { fetchPosts, Like, Post } from "../api";
import { initialState, reducer } from "../reducer";
import { useEventSource, SourceContext } from "../eventsource";
import { PostsContext } from "./Posts";

export interface SourceReducerProps {
  eventSourceURL: string;
}

export function SourceReducer({ eventSourceURL, children }: React.PropsWithChildren<SourceReducerProps>) {
  const [state, dispatch] = useReducer(reducer, initialState);

  useEffect(() => {
    fetchPosts().then((posts) => {
      dispatch({ type: "posts", data: posts });
    });
  }, []);

  const reload = () => {
    window.location.reload();
  };

  const newPost = (post: Post) => {
    dispatch({ type: "posts/new", data: post });
  };

  const newLike = (like: Like) => {
    dispatch({ type: "likes/new", data: like });
  };

  const source = useEventSource(eventSourceURL, {
    "posts/new": newPost,
    "likes/new": newLike,
    "system/reload": reload,
  });

  return (
    <SourceContext.Provider value={source}>
      <PostsContext.Provider value={state.posts}>{children}</PostsContext.Provider>
    </SourceContext.Provider>
  );
}
