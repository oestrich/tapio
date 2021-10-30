export interface Post {
    id: number;
    body: string;
    username: string;
    inserted_at: string;
    likes_count: number;
}
declare const fetchPosts: () => Promise<Post[]>;
declare const createPost: (body: string) => void;
declare const createLike: (post: Post) => void;
export { createLike, createPost, fetchPosts };
