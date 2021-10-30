/// <reference types="react" />
declare const SocketContext: import("react").Context<any>;
export declare function useWebsocket(webSocketURL: string, eventHandlers: Object): WebSocket;
export { SocketContext };
