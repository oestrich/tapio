export interface Post {
    id: number;
    body: string;
    username: string;
    inserted_at: string;
    likes_count: number;
}
export interface Like {
    post_id: number;
}
declare const fetchPosts: () => Promise<Post[]>;
declare const createPost: (body: string) => Promise<boolean>;
declare const createLike: (post: Post) => Promise<boolean>;
export { createLike, createPost, fetchPosts };
