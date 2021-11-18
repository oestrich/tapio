import * as React from "react";
import { useCallback, useState } from "react";

import { createLike, Post as ApiPost } from "../api";

function LikedStatus({ status }) {
  switch (status) {
    case "liked":
      return <span className="text-green-600">Liked</span>;
    case "failed":
      return <span className="text-red-600">You already liked this!</span>;
  }

  return null;
}

export function Post(post: ApiPost) {
  const [likedStatus, setLikedStatus] = useState(null);

  const onLikeClick = useCallback(
    async (e) => {
      e.preventDefault();

      createLike(post).then((success) => {
        if (success) {
          setLikedStatus("liked");
        } else {
          setLikedStatus("failed");
        }
      });
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
          <span className="like-count" title="Number of likes">
            {post.likes_count}
          </span>
          <LikedStatus status={likedStatus} />
          <a href="#" onClick={onLikeClick} className="like pl-3 text-sm">
            Like
          </a>
        </div>
      </div>
    </div>
  );
}
