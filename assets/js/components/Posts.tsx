import * as React from "react";
import { useContext } from "react";

import { Post } from "./Post";

const PostsContext = React.createContext([]);

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
