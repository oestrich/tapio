import * as React from "react";

export interface Post {
  id: number;
  body: string;
  username: string;
  inserted_at: string;
}

export function Post(post: Post) {
  return (
    <div className="mx-3 w-full" data-post-id={`${post.id}`}>
      <p className="">{post.body}</p>

      <div className="flex flex-row justify-between w-full">
        <div className="text-sm text-gray-400">
          <span className="text-green-600">{post.username}</span> at {post.inserted_at}
        </div>
        <div>
          <span className="like-count">0</span> <a href={`/posts/${post.id}/like`} className="like pl-3 text-sm">Like</a>
        </div>
      </div>
    </div>
  );
}
