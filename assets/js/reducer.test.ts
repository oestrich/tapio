import { reducer } from "./reducer";

describe("reducer", () => {
  test("setting posts", () => {
    const post = {
      body: "A new post",
    };

    const state = reducer({ posts: [] }, { type: "posts", data: [post] });

    expect(state.posts).toStrictEqual([post]);
  });
});
