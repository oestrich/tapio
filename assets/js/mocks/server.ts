import { setupServer } from "msw/node";

import { rest } from "msw";

const handlers = [
  rest.post("/posts/201/like", (req, res, ctx) => {
    return res(ctx.status(201), ctx.json({}));
  }),
  rest.post("/posts/400/like", (req, res, ctx) => {
    return res(ctx.status(400), ctx.json({}));
  }),
];

export const server = setupServer(...handlers);
