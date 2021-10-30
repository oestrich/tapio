import * as React from "react";
import { useCallback, useContext, useState } from "react";

import { createLike, createPost, Post as ApiPost } from "./api";

const PostsContext = React.createContext([]);

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

export function CreatePost() {
  const [body, setBody] = useState("");
  const [isShiftPressed, setIsShiftPressed] = useState(false);

  const onKeyUp = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key == "Shift") {
      setIsShiftPressed(false);
    }
  };

  const onKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key == "Shift") {
      setIsShiftPressed(true);
    }

    if (e.key == "Enter" && !isShiftPressed) {
      e.preventDefault();
      createPost(body);
      setBody("");
    }
  };

  const onChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setBody(e.target.value);
  };

  return (
    <form id="post" action="<%= Routes.posts_path(token) %>" method="post">
      <div className="mb-2">
        <label className="block text-gray-700 font-bold mb-2" htmlFor="post_body">
          What's on your mind?
        </label>

        <textarea
          name="body"
          id="post_body"
          className="shadow rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          autoFocus={true}
          onKeyUp={onKeyUp}
          onKeyDown={onKeyDown}
          onChange={onChange}
          value={body}
        ></textarea>
      </div>

      <input
        type="submit"
        value="post"
        className="hidden cursor-pointer bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
      />
    </form>
  );
}

export function Posts() {
  const posts = useContext(PostsContext);

  return (
    <>
      <h2 className="text-xl my-4">latest posts</h2>

      <ul role="list" id="posts" className="pb-4 mt-4">
        {posts.map((post) => {
          return (
            <li key={post.id} className="my-4 py-4 flex rounded bg-white shadow">
              <Post {...post} />
            </li>
          );
        })}
      </ul>
    </>
  );
}

export { PostsContext };
