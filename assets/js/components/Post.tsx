import * as React from "react";
import { useCallback } from "react";

import { createLike, Post as ApiPost } from "../api";

export function Post(post: ApiPost) {
  const onLikeClick = useCallback(
    (e) => {
      e.preventDefault();

      createLike(post);
    },
    [post],
  );

  return (
    <div className="mx-3 w-full" data-post-id={`${post.id}`}>
      <p className="">{post.body}</p>

      <div className="flex flex-row justify-between w-full">
        <div className="text-sm text-gray-400">
          <span className="text-green-600">{post.username}</span> at {post.inserted_at}
        </div>
        <div>
          <span className="like-count">{post.likes_count}</span>{" "}
          <a href="#" onClick={onLikeClick} className="like pl-3 text-sm">
            Like
          </a>
        </div>
      </div>
    </div>
  );
}
