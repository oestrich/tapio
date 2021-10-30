import { Post } from "./api";
interface State {
    posts: Post[];
}
interface Action {
    type: string;
    data: any;
}
declare const reducer: (state: State, action: Action) => State;
declare const initialState: {
    posts: any[];
};
export { initialState, reducer };
