import * as React from "react";
import { useCallback, useEffect, useState } from "react";
import * as ReactDOM from "react-dom";

import { fetchPosts, CreatePost, Post, Posts, PostsContext }  from "./posts";
import { useWebsocket, SocketContext } from "./websocket";

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

interface App {
  webSocketURL: string;
}

function App({ webSocketURL }: App) {
  const [posts, setPosts] = useState([]);

  useEffect(() => {
    fetchPosts().then((posts) => {
      setPosts(posts);
    });
  }, []);

  let newPost = useCallback((post: Post) => {
    setPosts([post, ...posts]);
  }, [posts]);

  let newLike = useCallback((like: Like) => {
    setPosts(posts.map((post) => {
      if (post.id == like.post_id) {
        post.likes_count += 1;
      }
      return post;
    }));
  }, [posts]);

  let socket = useWebsocket(webSocketURL, {
    "posts/new": newPost,
    "likes/new": newLike,
  });

  return (
    <SocketContext.Provider value={socket}>
      <PostsContext.Provider value={posts}>
        <CreatePost />
        <Posts />
      </PostsContext.Provider>
    </SocketContext.Provider>
  );
}

const components = {
  App
};

/**
 * ReactPhoenix
 *
 * Copied from https://github.com/geolessel/react-phoenix/blob/master/src/react_phoenix.js
 */
class ReactPhoenix {
  static init() {
    const elements = document.querySelectorAll("[data-react-class]");

    elements.forEach((e: HTMLElement) => {
      const targetId = document.getElementById(e.dataset.reactTargetId);
      const targetDiv = targetId ? targetId : e;
      const reactProps = e.dataset.reactProps ? e.dataset.reactProps : "{}";
      const reactElement = React.createElement(components[e.dataset.reactClass], JSON.parse(reactProps));
      ReactDOM.render(reactElement, targetDiv);
    });
  }
}

document.addEventListener("DOMContentLoaded", () => {
  ReactPhoenix.init();
});
