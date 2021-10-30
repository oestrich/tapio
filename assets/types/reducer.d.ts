import * as React from "react";
export interface SocketReducerProps {
    webSocketURL: string;
}
export declare function SocketReducer({ webSocketURL, children }: React.PropsWithChildren<SocketReducerProps>): JSX.Element;
