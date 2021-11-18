/**
 * @jest-environment jsdom
 */

import * as React from "react";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import "@testing-library/jest-dom";

import { Post } from "./Post";

test("renders correctly", () => {
  render(<Post id={201} body={"Hello!"} username={"user"} inserted_at={"Yesterday"} likes_count={0} />);

  const likes = screen.getByTitle("Number of likes");
  expect(likes.innerHTML).toEqual("0");

  const username = screen.getByText("user");
  expect(username).toBeTruthy();
});

test("can like a post", async () => {
  render(<Post id={201} body={"Hello!"} username={"user"} inserted_at={"Yesterday"} likes_count={0} />);

  fireEvent.click(screen.getByText("Like"));

  await waitFor(() => screen.findByText("Liked"));
});

test("already liked a post", async () => {
  render(<Post id={400} body={"Hello!"} username={"user"} inserted_at={"Yesterday"} likes_count={0} />);

  fireEvent.click(screen.getByText("Like"));

  await waitFor(() => screen.findByText("You already liked this!"));
});
