import * as React from "react";
import { Post as ApiPost } from "./api";
declare const PostsContext: React.Context<any[]>;
export declare function Post(post: ApiPost): JSX.Element;
export declare function CreatePost(): JSX.Element;
export declare function Posts(): JSX.Element;
export { PostsContext };
