import * as React from "react";
import { useState } from "react";

import { createPost } from "../api";

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
