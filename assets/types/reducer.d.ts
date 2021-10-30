import * as React from "react";
export interface SocketReducer {
    webSocketURL: string;
}
export declare function SocketReducer({ webSocketURL, children }: React.PropsWithChildren<SocketReducer>): JSX.Element;
