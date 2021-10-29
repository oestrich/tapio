import { createContext, useEffect, useState} from "react";

const SocketContext = createContext(null);

export function useWebsocket(webSocketURL: string, eventHandlers: Object): WebSocket {
  const [socket, setSocket] = useState(null as unknown as WebSocket);

  useEffect(() => {
    const socket = new WebSocket(webSocketURL);

    setSocket(socket);

    return () => {
      socket.close();
    };
  }, []);

  useEffect(() => {
    if (!socket) return;

    socket.onmessage = (e: MessageEvent) => {
      const message = JSON.parse(e.data);

      if (eventHandlers[message.event]) {
        const handler = eventHandlers[message.event];

        handler(message.data);
      }
    };
  }, [eventHandlers]);

  return socket;
}

export { SocketContext };
