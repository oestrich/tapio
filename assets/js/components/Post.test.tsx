/**
 * @jest-environment jsdom
 */

import * as React from "react";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";

import { Post } from "./Post";

test("renders correctly", () => {
  render(<Post id={1} body={"Hello!"} username={"user"} inserted_at={"Yesterday"} likes_count={0} />);

  const likes = screen.getByTitle("Number of likes");
  expect(likes.innerHTML).toEqual("0");
});
