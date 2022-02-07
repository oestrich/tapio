import { createContext, useEffect, useState } from "react";

const SourceContext = createContext(null);

export function useEventSource(eventSourceURL: string, eventHandlers: Object): EventSource {
  const [source, setSource] = useState(null as unknown as EventSource);

  useEffect(() => {
    const source = new EventSource(eventSourceURL);

    setSource(source);

    if (!source) {
      return;
    }

    for (let [key, handler] of Object.entries(eventHandlers)) {
      source.addEventListener(key, (e: MessageEvent) => {
        const message = JSON.parse(e.data);
        handler(message);
      });
    }

    return () => {
      source.close();
    };
  }, []);

  return source;
}

export { SourceContext };
