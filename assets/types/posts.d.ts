import * as React from "react";
declare const PostsContext: React.Context<any[]>;
export interface Post {
    id: number;
    body: string;
    username: string;
    inserted_at: string;
    likes_count: number;
}
declare const fetchPosts: () => Promise<Post[]>;
export declare function Post(post: Post): JSX.Element;
export declare function CreatePost(): JSX.Element;
export declare function Posts(): JSX.Element;
export { fetchPosts, PostsContext, };
